#ifndef LIBUVC_CONFIG_H
#define LIBUVC_CONFIG_H

#define LIBUVC_VERSION_MAJOR 1
#define LIBUVC_VERSION_MINOR 0
#define LIBUVC_VERSION_PATCH 0
#define LIBUVC_VERSION_STR "1.0.0"
#define LIBUVC_VERSION_INT           \
  ((@libuvc_VERSION_MAJOR @ << 16) | \
   (@libuvc_VERSION_MINOR @ << 8) |  \
   (@libuvc_VERSION_PATCH @))

/** @brief Test whether libuvc is new enough
 * This macro evaluates true if and only if the current version is
 * at least as new as the version specified.
 */
#define LIBUVC_VERSION_GTE(major, minor, patch) \
  (LIBUVC_VERSION_INT >= (((major) << 16) | ((minor) << 8) | (patch)))

// #define LIBUVC_HAS_JPEG 1
#undef LIBUVC_HAS_JPEG

#endif // !def(LIBUVC_CONFIG_H)
