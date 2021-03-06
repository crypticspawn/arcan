/*
 * cfg is generated at build time, pulls in the platform defintion.
 */
#include "arcan_shmif_cfg.h"

#ifdef gl21
#ifndef SHMIF_RGBA
#define SHMIF_RGBA(r, g, b, a)(\
((uint32_t) (a) << 24) |\
((uint32_t) (r) << 16) |\
((uint32_t) (g) << 8)  |\
((uint32_t) (b)) )
#endif

#ifndef SHMIF_RGBA_DECOMP
static inline void SHMIF_RGBA_DECOMP(shmif_pixel val,
	uint8_t* r, uint8_t* g, uint8_t* b, uint8_t* a)
{
	*b = (val & 0x000000ff);
	*g = (val & 0x0000ff00) >>  8;
	*r = (val & 0x00ff0000) >> 16;
	*a = (val & 0xff000000) >> 24;
}
#endif
#else
#ifndef SHMIF_RGBA
#define SHMIF_RGBA(r, g, b, a)(\
((uint32_t) (a) << 24) |\
((uint32_t) (b) << 16) |\
((uint32_t) (g) << 8)  |\
((uint32_t) (r)) )
#endif

#ifndef SHMIF_RGBA_DECOMP
static inline void SHMIF_RGBA_DECOMP(shmif_pixel val,
	uint8_t* r, uint8_t* g, uint8_t* b, uint8_t* a)
{
	*r = (val & 0x000000ff);
	*g = (val & 0x0000ff00) >>  8;
	*b = (val & 0x00ff0000) >> 16;
	*a = (val & 0xff000000) >> 24;
}
#endif
#endif
