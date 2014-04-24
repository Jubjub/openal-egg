;;;; openal.scm


(module openal (openal:device-list
		openal:make-buffer
		openal:make-source
		openal:load-buffer)
  (import scheme chicken foreign)
  (use al alc alut srfi-4 lolevel data-structures)

(define (openal:device-list)
  (string-split
   ((foreign-lambda* c-string* ((int id)) #<<EOF
     extern char *alcGetString(void *, int);
     int i;
     char *lst = alcGetString(NULL, id);
     char *dst = (char *)malloc(strlen(lst) + 2);
     if(dst == NULL) return(NULL);
     if(lst == NULL) return("\0");
     for(i = 0; lst[ i ] != '\0' || lst[ i + 1 ] != '\0'; ++i)
       if(lst[ i ] == '\0') dst[ i ] = '/';
       dst[ i ] = lst[ i ];
     return(lst);
EOF
)
    alc:DEVICE_SPECIFIER)
   "/") )

(apply alut:Init (receive (argc+argv)))

(declare (hide check))

(define (check thunk #!optional (msg "OpenAL operation failed") . args)
  (al:GetError)
  (call-with-values thunk
    (lambda results
      (let ((err (al:GetError)))
	(unless (= err al:NO_ERROR)
	  (abort
	   (make-composite-condition
	    (make-property-condition 'exn 'message msg 'arguments (if (pair? args) args (list err)))
	    (make-property-condition 'openal 'class 'AL 'code err) ) ) ) )
	(apply values results) ) ) )

(define (check/device thunk device #!optional (msg "OpenAL operation failed") . args)
  (alc:GetError device)
  (call-with-values (lambda () (apply check thunk msg args))
    (lambda results
      (let ((err (alc:GetError device)))
	(unless (= err alc:NO_ERROR)
	  (abort
	   (make-composite-condition
	    (make-property-condition 'exn 'message msg 'arguments (if (pair? args) args (list err)))
	    (make-property-condition 'openal 'class 'ALC 'code err) ) ) ) )
	(apply values results) ) ) )

(define (openal:make-buffer data stereo freq)
  (let ((buf (check
	      (lambda ()
		(let ((v (make-u32vector 1)))
		  (al:GenBuffers 1 v)
		  (u32vector-ref v 0) ) ) 
	      "can not generate buffer") ) )
    (check
     (lambda () 
       (al:BufferData 
	buf 
	(cond ((u8vector? data) (if stereo al:FORMAT_STEREO8 al:FORMAT_MONO8))
	      ((s16vector? data) (if stereo al:FORMAT_STEREO16 al:FORMAT_MONO16))
	      (else (error 'make-openal-buffer "invalid data format" data)) )
	(make-locative data)
	(if (u8vector? data) (u8vector-length data) (fx* 2 (s16vector-length data)))
	freq)
       buf)
     "can not set buffer data" buf data) ) )

(define (openal:make-source #!optional buf)
  (let ((src (check
	      (lambda ()
		(let ((v (make-u32vector 1)))
		  (al:GenSources 1 v)
		  (u32vector-ref v 0) ) )
	      "can not generate source") ) )
    (check
     (lambda ()
       (al:Sourcei src al:BUFFER buf) ) )
    src) )

(define (openal:load-buffer filename)
  (let-values (((format data size freq loop)
		(check (cut alut:LoadWAVFile filename) "can not load WAV" filename) ) )
    (let ((v (make-u32vector 1)))
      (check (cut al:GenBuffers 1 v) "can not generate buffer for WAV" filename)
      (let ((buf (u32vector-ref v 0)))
	(check (cut al:BufferData buf format data size freq) "can not set buffer data for WAV" filename)
	(alut:UnloadWAV format data size freq)
	buf) ) ) )

)
