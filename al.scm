;;;; al.scm

(module al * 
  (import scheme chicken foreign)
  (use easyffi)

#>
#ifdef C_MACOSX
#include <OpenAL/al.h>
#else
#include <AL/al.h>
#endif
<#

(define (get-srfi-4-buffer v)
  (##sys#slot v 1) )

(foreign-parse #<<EOF

___declare(export_constants, yes)
___declare(substitute, "^(AL_|al);al:")
___declare(type, "srfi4buffer;byte-vector;get-srfi-4-buffer")

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

/* Bad value. */
#define AL_INVALID                               -1

/* Disable value. */
#define AL_NONE									 0

/* Boolean False. */
#define AL_FALSE                                 0

/* Boolean True. */
#define AL_TRUE                                  1

/**
  * Indicate the type of AL_SOURCE.
  * Sources can be spatialized 
  */
#define AL_SOURCE_TYPE                           0x200

/** Indicate source has absolute coordinates. */
#define AL_SOURCE_ABSOLUTE                       0x201

/** Indicate Source has listener relative coordinates. */
#define AL_SOURCE_RELATIVE                       0x202

/**
 * Directional source, inner cone angle, in degrees.
 * Range:    [0-360] 
 * Default:  360
 */
#define AL_CONE_INNER_ANGLE                      0x1001

/**
 * Directional source, outer cone angle, in degrees.
 * Range:    [0-360] 
 * Default:  360
 */
#define AL_CONE_OUTER_ANGLE                      0x1002

/**
 * Specify the pitch to be applied, either at source,
 *  or on mixer results, at listener.
 * Range:	 [0.5-2.0]
 * Default:  1.0
 */
#define AL_PITCH                                 0x1003

/** 
 * Specify the current location in three dimensional space.
 * OpenAL, like OpenGL, uses a right handed coordinate system,
 *  where in a frontal default view X (thumb) points right, 
 *  Y points up (index finger), and Z points towards the
 *  viewer/camera (middle finger). 
 * To switch from a left handed coordinate system, flip the
 *  sign on the Z coordinate.
 * Listener position is always in the world coordinate system.
 */ 
#define AL_POSITION                              0x1004
  
/** Specify the current direction as forward vector. */
#define AL_DIRECTION                             0x1005
  
/** Specify the current velocity in three dimensional space. */
#define AL_VELOCITY                              0x1006

/**
 * Indicate whether source has to loop infinite.
 * Type: ALboolean
 * Range:    [AL_TRUE, AL_FALSE]
 * Default:  AL_FALSE
 */
#define AL_LOOPING                               0x1007

/**
 * Indicate the buffer to provide sound samples. 
 * Type: ALuint.
 * Range: any valid Buffer id.
 */
#define AL_BUFFER                                0x1009

/**
 * Indicate the gain (volume amplification) applied. 
 * Type:     ALfloat.
 * Range:    ]0.0-  ]
 * A value of 1.0 means un-attenuated/unchanged.
 * Each division by 2 equals an attenuation of -6dB.
 * Each multiplicaton with 2 equals an amplification of +6dB.
 * A value of 0.0 is meaningless with respect to a logarithmic
 *  scale; it is interpreted as zero volume - the channel
 *  is effectively disabled.
 */
#define AL_GAIN                                  0x100A

/**
 * Indicate minimum source attenuation.
 * Type:     ALfloat
 * Range:	 [0.0 - 1.0]
 */
#define AL_MIN_GAIN                              0x100D

/**
 * Indicate maximum source attenuation.
 * Type:	 ALfloat
 * Range:	 [0.0 - 1.0]
 */
#define AL_MAX_GAIN                              0x100E

/** 
 * Specify the current orientation.
 * Type:	 ALfv6 (at/up)
 * Range:	 N/A
 */
#define AL_ORIENTATION                           0x100F

/* byte offset into source (in canon format).  -1 if source
 * is not playing.  Don't set this, get this.
 *
 * Type:     ALfloat
 * Range:    [0.0 - ]
 * Default:  1.0
 */
#define AL_REFERENCE_DISTANCE                    0x1020

 /**
 * Indicate the rolloff factor for the source.
 * Type: ALfloat
 * Range:    [0.0 - ]
 * Default:  1.0
 */
#define AL_ROLLOFF_FACTOR                        0x1021

/**
 * Indicate the gain (volume amplification) applied. 
 * Type:     ALfloat.
 * Range:    ]0.0-  ]
 * A value of 1.0 means un-attenuated/unchanged.
 * Each division by 2 equals an attenuation of -6dB.
 * Each multiplicaton with 2 equals an amplification of +6dB.
 * A value of 0.0 is meaningless with respect to a logarithmic
 *  scale; it is interpreted as zero volume - the channel
 *  is effectively disabled.
 */
#define AL_CONE_OUTER_GAIN                       0x1022

/** 
 * Specify the maximum distance.
 * Type:	 ALfloat
 * Range:	 [0.0 - ]
 */
#define AL_MAX_DISTANCE                          0x1023

/**
 * Source state information
 */
#define AL_SOURCE_STATE                          0x1010
#define AL_INITIAL                               0x1011
#define AL_PLAYING                               0x1012
#define AL_PAUSED                                0x1013
#define AL_STOPPED                               0x1014

/**
 * Buffer Queue params
 */
#define AL_BUFFERS_QUEUED                        0x1015
#define AL_BUFFERS_PROCESSED                     0x1016

/** Sound buffers: format specifier. */
#define AL_FORMAT_MONO8                          0x1100
#define AL_FORMAT_MONO16                         0x1101
#define AL_FORMAT_STEREO8                        0x1102
#define AL_FORMAT_STEREO16                       0x1103

/** 
 * Sound buffers: frequency, in units of Hertz [Hz].
 * This is the number of samples per second. Half of the
 *  sample frequency marks the maximum significant
 *  frequency component.
 */
#define AL_FREQUENCY                             0x2001
#define AL_BITS                                  0x2002
#define AL_CHANNELS                              0x2003
#define AL_SIZE                                  0x2004
#define AL_DATA                                  0x2005

/**
 * Buffer state.
 *
 * Not supported for public use (yet).
 */
#define AL_UNUSED                                0x2010
#define AL_PENDING                               0x2011
#define AL_PROCESSED                             0x2012

/** Errors: No Error. */
#define AL_NO_ERROR                              0

/** 
 * Illegal name passed as an argument to an AL call.
 */
#define AL_INVALID_NAME                          0xA001

/** 
 * Illegal enum passed as an argument to an AL call.
 */
#define AL_INVALID_ENUM                          0xA002  
/** 
 * Illegal value passed as an argument to an AL call.
 * Applies to parameter values, but not to enumerations.
 */
#define AL_INVALID_VALUE                         0xA003
  
/**
 * A function was called at inappropriate time,
 *  or in an inappropriate way, causing an illegal state.
 * This can be an incompatible ALenum, object ID,
 *  and/or function.
 */
#define AL_INVALID_OPERATION                     0xA004

/**
 * A function could not be completed,
 * because there is not enough memory available.
 */
#define AL_OUT_OF_MEMORY                         0xA005

/** Context strings: Vendor Name. */
#define AL_VENDOR                                0xB001
#define AL_VERSION                               0xB002
#define AL_RENDERER                              0xB003
#define AL_EXTENSIONS                            0xB004

/** Global tweakage. */

/**
 * Doppler scale.  Default 1.0
 */
#define AL_DOPPLER_FACTOR                        0xC000
 
/**
 * Doppler velocity.  Default 1.0
 */
#define AL_DOPPLER_VELOCITY                      0xC001

/**
 * Distance model.  Default AL_INVERSE_DISTANCE_CLAMPED
 */
#define AL_DISTANCE_MODEL                        0xD000

/** Distance models. */

#define AL_INVERSE_DISTANCE                      0xD001
#define AL_INVERSE_DISTANCE_CLAMPED              0xD002
 
#define ALAPI
#define ALAPIENTRY

/**
 * OpenAL Maintenance Functions
 * Initialization and exiting.
 * State Management and Query.
 * Error Handling.
 * Extension Support.
 */

/** State management. */
ALAPI ALvoid	ALAPIENTRY alEnable( ALenum capability );
ALAPI ALvoid	ALAPIENTRY alDisable( ALenum capability ); 
ALAPI ALboolean ALAPIENTRY alIsEnabled( ALenum capability ); 

/** Application preferences for driver performance choices. */
//ALAPI ALvoid	ALAPIENTRY alHint( ALenum target, ALenum mode );

/** State retrieval. */
ALAPI ALboolean ALAPIENTRY alGetBoolean( ALenum param );
ALAPI ALint		ALAPIENTRY alGetInteger( ALenum param );
ALAPI ALfloat	ALAPIENTRY alGetFloat( ALenum param );
ALAPI ALdouble	ALAPIENTRY alGetDouble( ALenum param );
ALAPI ALvoid	ALAPIENTRY alGetBooleanv( ALenum param, ALubyte* data );
ALAPI ALvoid	ALAPIENTRY alGetIntegerv( ALenum param, ALint* data );
ALAPI ALvoid	ALAPIENTRY alGetFloatv( ALenum param, ALfloat* data );
ALAPI ALvoid	ALAPIENTRY alGetDoublev( ALenum param, ALdouble* data );
ALAPI char*	ALAPIENTRY alGetString( ALenum param );

ALAPI ALvoid	ALAPIENTRY alSetInteger( ALenum pname, ALint value );
ALAPI ALvoid	ALAPIENTRY alSetDouble( ALenum pname, ALdouble value );

/**
 * Error support.
 * Obtain the most recent error generated in the AL state machine.
 */
ALAPI ALenum	ALAPIENTRY alGetError();


/** 
 * Extension support.
 * Obtain the address of a function (usually an extension)
 *  with the name fname. All addresses are context-independent. 
 */
ALAPI ALboolean ALAPIENTRY alIsExtensionPresent( char* fname );


/** 
 * Extension support.
 * Obtain the address of a function (usually an extension)
 *  with the name fname. All addresses are context-independent. 
 */
ALAPI ALvoid*	ALAPIENTRY alGetProcAddress( char* fname );


/**
 * Extension support.
 * Obtain the integer value of an enumeration (usually an extension) with the name ename. 
 */
ALAPI ALenum	ALAPIENTRY alGetEnumValue( char* ename );




/**
 * LISTENER
 * Listener is the sample position for a given context.
 * The multi-channel (usually stereo) output stream generated
 *  by the mixer is parametrized by this Listener object:
 *  its position and velocity relative to Sources, within
 *  occluder and reflector geometry.
 */



/**
 *
 * Listener Environment:  default 0.
 */
ALAPI ALvoid	ALAPIENTRY alListeneri( ALenum param, ALint value );


/**
 *
 * Listener Gain:  default 1.0f.
 */
ALAPI ALvoid	ALAPIENTRY alListenerf( ALenum param, ALfloat value );


/**  
 *
 * Listener Position.
 * Listener Velocity.
 */
ALAPI ALvoid	ALAPIENTRY alListener3f( ALenum param, ALfloat v1, ALfloat v2, ALfloat v3 ); 


/**
 *
 * Listener Position:        ALfloat[3]
 * Listener Velocity:        ALfloat[3]
 * Listener Orientation:     ALfloat[6]  (forward and up vector).
 */
ALAPI ALvoid	ALAPIENTRY alListenerfv( ALenum param, ALfloat* values ); 

ALAPI ALvoid	ALAPIENTRY alGetListeneri( ALenum param, ___out ALint* value );
ALAPI ALvoid	ALAPIENTRY alGetListenerf( ALenum param, ___out ALfloat* value );
ALAPI ALvoid	ALAPIENTRY alGetListener3f( ALenum param, ___out ALfloat* v1, ___out ALfloat* v2, ___out ALfloat* v3 ); 
ALAPI ALvoid	ALAPIENTRY alGetListenerfv( ALenum param, ALfloat* values ); 


/**
 * SOURCE
 * Source objects are by default localized. Sources
 *  take the PCM data provided in the specified Buffer,
 *  apply Source-specific modifications, and then
 *  submit them to be mixed according to spatial 
 *  arrangement etc.
 */



/** Create Source objects. */
ALAPI ALvoid	ALAPIENTRY alGenSources( ALsizei n, ALuint* sources ); 

/** Delete Source objects. */
ALAPI ALvoid	ALAPIENTRY alDeleteSources( ALsizei n, ALuint* sources );

/** Verify a handle is a valid Source. */ 
ALAPI ALboolean ALAPIENTRY alIsSource( ALuint id ); 

/** Set an integer parameter for a Source object. */
ALAPI ALvoid	ALAPIENTRY alSourcei( ALuint source, ALenum param, ALint value ); 
ALAPI ALvoid	ALAPIENTRY alSourcef( ALuint source, ALenum param, ALfloat value ); 
ALAPI ALvoid	ALAPIENTRY alSource3f( ALuint source, ALenum param, ALfloat v1, ALfloat v2, ALfloat v3 );
ALAPI ALvoid	ALAPIENTRY alSourcefv( ALuint source, ALenum param, ALfloat* values ); 

/** Get an integer parameter for a Source object. */
ALAPI ALvoid	ALAPIENTRY alGetSourcei( ALuint source,  ALenum param, ___out ALint* value );
ALAPI ALvoid	ALAPIENTRY alGetSourcef( ALuint source,  ALenum param, ___out ALfloat* value );
ALAPI ALvoid	ALAPIENTRY alGetSource3f( ALuint source,  ALenum param, ___out ALfloat* v1, ___out ALfloat* v2, ___out ALfloat* v3 );
ALAPI ALvoid	ALAPIENTRY alGetSourcefv( ALuint source, ALenum param, ALfloat* values );

ALAPI ALvoid	ALAPIENTRY alSourcePlayv( ALsizei n, ALuint *sources );
ALAPI ALvoid	ALAPIENTRY alSourcePausev( ALsizei n, ALuint *sources );
ALAPI ALvoid	ALAPIENTRY alSourceStopv( ALsizei n, ALuint *sources );
ALAPI ALvoid	ALAPIENTRY alSourceRewindv(ALsizei n,ALuint *sources);

/** Activate a source, start replay. */
ALAPI ALvoid	ALAPIENTRY alSourcePlay( ALuint source );

/**
 * Pause a source, 
 *  temporarily remove it from the mixer list.
 */
ALAPI ALvoid	ALAPIENTRY alSourcePause( ALuint source );

/**
 * Stop a source,
 *  temporarily remove it from the mixer list,
 *  and reset its internal state to pre-Play.
 * To remove a Source completely, it has to be
 *  deleted following Stop, or before Play.
 */
ALAPI ALvoid	ALAPIENTRY alSourceStop( ALuint source );

/**
 * Rewinds a source, 
 *  temporarily remove it from the mixer list,
 *  and reset its internal state to pre-Play.
 */
ALAPI ALvoid	ALAPIENTRY alSourceRewind( ALuint source );



/**
 * BUFFER
 * Buffer objects are storage space for sample data.
 * Buffers are referred to by Sources. There can be more than
 *  one Source using the same Buffer data. If Buffers have
 *  to be duplicated on a per-Source basis, the driver has to
 *  take care of allocation, copying, and deallocation as well
 *  as propagating buffer data changes.
 */




/** Buffer object generation. */
ALAPI ALvoid 	ALAPIENTRY alGenBuffers( ALsizei n, ALuint* buffers );
ALAPI ALvoid	ALAPIENTRY alDeleteBuffers( ALsizei n, ALuint* buffers );
ALAPI ALboolean ALAPIENTRY alIsBuffer( ALuint buffer );

/**
 * Specify the data to be filled into a buffer.
 */
ALAPI ALvoid	ALAPIENTRY alBufferData( ALuint   buffer,
										 ALenum   format,
										 void *data,
										 ALsizei  size,
										 ALsizei  freq );


ALAPI ALvoid	ALAPIENTRY alGetBufferi( ALuint buffer, ALenum param, ALint*   value );
ALAPI ALvoid	ALAPIENTRY alGetBufferf( ALuint buffer, ALenum param, ALfloat* value );




/**
 * Queue stuff
 */

ALAPI ALvoid	ALAPIENTRY alSourceQueueBuffers( ALuint source, ALsizei n, ALuint* buffers );
ALAPI ALvoid	ALAPIENTRY alSourceUnqueueBuffers( ALuint source, ALsizei n, ALuint* buffers );

/**
 * Knobs and dials
 */
ALAPI ALvoid	ALAPIENTRY alDistanceModel( ALenum value );
ALAPI ALvoid	ALAPIENTRY alDopplerFactor( ALfloat value );
ALAPI ALvoid	ALAPIENTRY alDopplerVelocity( ALfloat value );

EOF
)

)
