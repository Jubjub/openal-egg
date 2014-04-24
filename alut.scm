;;;; alut.scm

(module alut *
  (import scheme chicken foreign)
  (use easyffi)

#>
#ifdef C_MACOSX
#include <OpenAL/alut.h>
#else
#include <AL/alut.h>
#endif
<#

(foreign-parse #<<EOF

___declare(export_constants, yes)
___declare(substitute, "^alut;alut:")

/** OpenAL boolean type. */
___declare(type, "ALboolean;bool")

/** OpenAL 8bit signed byte. */
typedef char ALbyte;

/** OpenAL 8bit unsigned byte. */
typedef unsigned char ALubyte;

/** OpenAL 16bit signed short integer type. */
typedef short ALshort;

/** OpenAL 16bit unsigned short integer type. */
typedef unsigned short ALushort;

/** OpenAL 32bit unsigned integer type. */
typedef unsigned int ALuint;

/** OpenAL 32bit signed integer type. */
typedef int ALint;

/** OpenAL 32bit floating point type. */
typedef float ALfloat;

/** OpenAL 64bit double point type. */
typedef double ALdouble;

/** OpenAL 32bit type. */
typedef unsigned int ALsizei;

/** OpenAL void type */
typedef void ALvoid;

/** OpenAL enumerations. */
typedef int ALenum;

#define ALUTAPI
#define ALUTAPIENTRY

ALUTAPI ALvoid	ALUTAPIENTRY alutInit(___in ALint *argc,___in char **argv);
ALUTAPI ALvoid	ALUTAPIENTRY alutExit();
ALUTAPI ALvoid  ALUTAPIENTRY alutUnloadWAV(ALenum format,ALvoid *data,ALsizei size,ALsizei freq);

EOF
)

#+macosx
(foreign-parse #<<EOF
ALUTAPI ALvoid	ALUTAPIENTRY alutLoadWAVFile(char *file,___out ALenum *format,___out ALvoid **data,___out ALsizei *size,___out ALsizei *freq);
ALUTAPI ALvoid  ALUTAPIENTRY alutLoadWAVMemory(void *memory,___out ALenum *format,___out ALvoid **data,___out ALsizei *size,___out ALsizei *freq);


EOF
)

#+(not macosx)
(foreign-parse #<<EOF
ALUTAPI ALvoid	ALUTAPIENTRY alutLoadWAVFile(char *file,___out ALenum *format,___out ALvoid **data,___out ALsizei *size,___out ALsizei *freq, ___out ALboolean *loop);
ALUTAPI ALvoid  ALUTAPIENTRY alutLoadWAVMemory(void *memory,___out ALenum *format,___out ALvoid **data,___out ALsizei *size,___out ALsizei *freq, ___out ALboolean *loop);

EOF
)

#+macosx
(define alut:LoadWAVFile
  (let ((alut:LoadWAVFile alut:LoadWAVFile))
    (lambda (file)
      (let-values (((f d s fr) (alut:LoadWAVFile file)))
	(values f d s fr #f) ) ) ) )

)
