/*
 * No copyright claimed, Public Domain
 */

/*
 * Cherry- picked OpenGL functions used by glshared/gl21 and possible
 * other GL- related functions. It should be populated by the corresponding
 * gl%w*%d%d.c file.
 *
 * For new agp/ entries that uses GL, expand and mark which agp file
 * that is involved.
 */

#ifdef __APPLE__
/* we already have a reasonably sane GL environment here */
#include <OpenGL/gl.h>
#include <OpenGL/glext.h>
#else

#ifdef GLES2
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#define GL_DEPTH24_STENCIL8 GL_DEPTH24_STENCIL8_OES
#ifndef GL_DEPTH_STENCIL_ATTACHMENT
#define GL_DEPTH_STENCIL_ATTACHMENT GL_STENCIL_ATTACHMENT
#endif

static void glDrawBuffer(){}
static void glReadBuffer(){}

#elif GLES3
#include <GLES3/gl3.h>
#include <GLES3/gl3ext.h>

#else

#ifdef __WINDOWS

#define NO_SDL_GLEXT
#include <SDL_opengl.h>
#include "glext.h"

#else
#include <GL/gl.h>
#include "glext.h"
#endif

#ifndef MAP_PREFIX
#define MAP_PREFIX extern
#endif

MAP_PREFIX PFNGLDELETEBUFFERSPROC glDeleteBuffers;
MAP_PREFIX PFNGLUNMAPBUFFERPROC glUnmapBuffer;
MAP_PREFIX PFNGLGENBUFFERSPROC glGenBuffers;
MAP_PREFIX PFNGLBUFFERDATAPROC glBufferData;
MAP_PREFIX PFNGLBINDBUFFERPROC glBindBuffer;
MAP_PREFIX PFNGLGENFRAMEBUFFERSPROC glGenFramebuffers;
MAP_PREFIX PFNGLBINDFRAMEBUFFERPROC glBindFramebuffer;
MAP_PREFIX PFNGLFRAMEBUFFERTEXTURE2DPROC glFramebufferTexture2D;
MAP_PREFIX PFNGLBINDRENDERBUFFERPROC glBindRenderbuffer;
MAP_PREFIX PFNGLRENDERBUFFERSTORAGEPROC glRenderbufferStorage;
MAP_PREFIX PFNGLFRAMEBUFFERRENDERBUFFERPROC glFramebufferRenderbuffer;
MAP_PREFIX PFNGLCHECKFRAMEBUFFERSTATUSPROC glCheckFramebufferStatus;
MAP_PREFIX PFNGLDELETEFRAMEBUFFERSPROC glDeleteFramebuffers;
MAP_PREFIX PFNGLDELETERENDERBUFFERSPROC glDeleteRenderbuffers;
MAP_PREFIX PFNGLENABLEVERTEXATTRIBARRAYPROC glEnableVertexAttribArray;
MAP_PREFIX PFNGLVERTEXATTRIBPOINTERPROC glVertexAttribPointer;
MAP_PREFIX PFNGLDISABLEVERTEXATTRIBARRAYPROC glDisableVertexAttribArray;
MAP_PREFIX PFNGLENABLEVERTEXATTRIBARRAYPROC glEnableVertexAttribArray;
MAP_PREFIX PFNGLUNIFORM1IPROC glUniform1i;
MAP_PREFIX PFNGLUNIFORM1FPROC glUniform1f;
MAP_PREFIX PFNGLUNIFORM2FPROC glUniform2f;
MAP_PREFIX PFNGLUNIFORM3FPROC glUniform3f;
MAP_PREFIX PFNGLUNIFORM4FPROC glUniform4f;
MAP_PREFIX PFNGLUNIFORMMATRIX4FVPROC glUniformMatrix4fv;
MAP_PREFIX PFNGLCREATEPROGRAMPROC glCreateProgram;
MAP_PREFIX PFNGLUSEPROGRAMPROC glUseProgram;
MAP_PREFIX PFNGLGETUNIFORMLOCATIONPROC glGetUniformLocation;
MAP_PREFIX PFNGLGETATTRIBLOCATIONPROC glGetAttributeLocation;
MAP_PREFIX PFNGLDELETEPROGRAMPROC glDeleteProgram;
MAP_PREFIX PFNGLDELETESHADERPROC glDeleteShader;
MAP_PREFIX PFNGLSHADERSOURCEPROC glShaderSource;
MAP_PREFIX PFNGLCOMPILESHADERPROC glCompileShader;
MAP_PREFIX PFNGLGETSHADERIVPROC glGetShaderiv;
MAP_PREFIX PFNGLGETSHADERINFOLOGPROC glGetShaderInfoLog;
MAP_PREFIX PFNGLATTACHSHADERPROC glAttachShader;
MAP_PREFIX PFNGLLINKPROGRAMPROC glLinkProgram;
MAP_PREFIX PFNGLGETPROGRAMIVPROC glGetProgramiv;
MAP_PREFIX PFNGLGENRENDERBUFFERSPROC glGenRenderbuffers;
MAP_PREFIX PFNGLMAPBUFFERARBPROC glMapBuffer;
MAP_PREFIX PFNGLGETATTRIBLOCATIONPROC glGetAttribLocation;
MAP_PREFIX PFNGLDELETEPROGRAMPROC glDeleteProgram;
MAP_PREFIX PFNGLCREATESHADERPROC glCreateShader;
MAP_PREFIX PFNGLACTIVETEXTUREPROC glActiveTexture;

/* part of 1.1 (i.e. all openGL libs), ignored
MAP_PREFIX PFNGLBINDTEXTUREEXTPROC glBindTexture;
MAP_PREFIX PFNGLDELETETEXTURESEXTPROC glDeleteTextures;
MAP_PREFIX PFNGLTEXSUBIMAGE2DEXTPROC glTexSubImage2D;
MAP_PREFIX PFNGLGETTEXTUREIMAGEEXTPROC glGetTexImage;
MAP_PREFIX glDrawBuffer;
MAP_PREFIX glReadBuffer;
MAP_PREFIX glEnable;
MAP_PREFIX glBlendFunc;
MAP_PREFIX glDisable;
MAP_PREFIX glFrontFace;
MAP_PREFIX glCullFace;
MAP_PREFIX glClearColor;
MAP_PREFIX glHint;
MAP_PREFIX glScissor;
MAP_PREFIX glViewport;
MAP_PREFIX glActiveTexture;
MAP_PREFIX glTexParameteri;
MAP_PREFIX glTexImage2D;
MAP_PREFIX glClearStencil;
MAP_PREFIX glColorMask;
MAP_PREFIX glStencilFunc;
MAP_PREFIX glStencilOp;
MAP_PREFIX glDisable;
MAP_PREFIX glDrawArrays;
MAP_PREFIX glDepthMask;
MAP_PREFIX glDrawElements;
MAP_PREFIX glReadPixels;
*/
#endif
#endif
