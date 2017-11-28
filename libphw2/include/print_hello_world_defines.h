#ifndef _PHW_DEFINES_H_
#define _PHW_DEFINES_H_

#undef PHW_BEGIN_C_DECLS
#undef PHW_END_C_DECLS
#ifdef __cplusplus
#  define PHW_BEGIN_C_DECLS extern "C" {
#  define PHW_END_C_DECLS }
#else /* !__cplusplus */
#  define PHW_BEGIN_C_DECLS
#  define PHW_END_C_DECLS
#endif  /* __cplusplus */

#if defined _WIN32 || defined __CYGWIN__
#  define PHW_HELPER_DLL_IMPORT __declspec(dllimport)
#  define PHW_HELPER_DLL_EXPORT __declspec(dllexport)
#  define PHW_HELPER_DLL_LOCAL
#else
#  if __GNUC__ >= 4
#    define PHW_HELPER_DLL_IMPORT __attribute__ ((visibility("default")))
#    define PHW_HELPER_DLL_EXPORT __attribute__ ((visibility("default")))
#    define PHW_HELPER_DLL_LOCAL  __attribute__ ((visibility("hidden")))
#  else
#    define PHW_HELPER_DLL_IMPORT
#    define PHW_HELPER_DLL_EXPORT
#    define PHW_HELPER_DLL_LOCAL
#  endif
#endif

#ifdef PHW_LIBRARIES_EXPORTS
#  ifdef PHW_SRC
#    define PHW_API PHW_HELPER_DLL_EXPORT
#  else
#    define PHW_API PHW_HELPER_DLL_IMPORT
#  endif
#  define PHW_LOCAL PHW_HELPER_DLL_LOCAL
#else
#  define PHW_API
#  define PHW_LOCAL
#endif

#endif
