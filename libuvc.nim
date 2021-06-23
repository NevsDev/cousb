import
  libuvc_config

discard "forward decl of libusb_context"
discard "forward decl of libusb_device_handle"
type                          ## * Success (no error)
  uvc_error_t* = enum
    UVC_ERROR_OTHER = -99, UVC_ERROR_CALLBACK_EXISTS = -52, ## * Undefined error
    UVC_ERROR_INVALID_MODE = -51, ## * Resource has a callback (can't use polling and async)
    UVC_ERROR_INVALID_DEVICE = -50, ## * Mode not supported
    UVC_ERROR_NOT_SUPPORTED = -12, ## * Device is not UVC-compliant
    UVC_ERROR_NO_MEM = -11,     ## * Operation not supported
    UVC_ERROR_INTERRUPTED = -10, ## * Insufficient memory
    UVC_ERROR_PIPE = -9,        ## * System call interrupted
    UVC_ERROR_OVERFLOW = -8,    ## * Pipe error
    UVC_ERROR_TIMEOUT = -7,     ## * Overflow
    UVC_ERROR_BUSY = -6,        ## * Operation timed out
    UVC_ERROR_NOT_FOUND = -5,   ## * Resource busy
    UVC_ERROR_NO_DEVICE = -4,   ## * Entity not found
    UVC_ERROR_ACCESS = -3,      ## * No such device
    UVC_ERROR_INVALID_PARAM = -2, ## * Access denied
    UVC_ERROR_IO = -1,          ## * Invalid parameter
    UVC_SUCCESS = 0             ## * Input/output error


## * Color coding of stream, transport-independent
##  @ingroup streaming
##

type
  uvc_frame_format* = enum
    UVC_FRAME_FORMAT_UNKNOWN = 0, ## * Any supported format
    UVC_FRAME_FORMAT_UNCOMPRESSED, UVC_FRAME_FORMAT_COMPRESSED, ## * YUYV/YUV2/YUV422: YUV encoding with one luminance value per pixel and
                                                              ##  one UV (chrominance) pair for every two pixels.
                                                              ##
    UVC_FRAME_FORMAT_YUYV, UVC_FRAME_FORMAT_UYVY, ## * 24-bit RGB
    UVC_FRAME_FORMAT_RGB, UVC_FRAME_FORMAT_BGR, ## * Motion-JPEG (or JPEG) encoded images
    UVC_FRAME_FORMAT_MJPEG, UVC_FRAME_FORMAT_H264, ## * Greyscale images
    UVC_FRAME_FORMAT_GRAY8, UVC_FRAME_FORMAT_GRAY16, ##  Raw colour mosaic images
    UVC_FRAME_FORMAT_BY8, UVC_FRAME_FORMAT_BA81, UVC_FRAME_FORMAT_SGRBG8,
    UVC_FRAME_FORMAT_SGBRG8, UVC_FRAME_FORMAT_SRGGB8, UVC_FRAME_FORMAT_SBGGR8, ## *
                                                                            ## YUV420: NV12
    UVC_FRAME_FORMAT_NV12,    ## * Number of formats understood
    UVC_FRAME_FORMAT_COUNT

const
  UVC_FRAME_FORMAT_ANY = UVC_FRAME_FORMAT_UNKNOWN

##  UVC_COLOR_FORMAT_* have been replaced with UVC_FRAME_FORMAT_*. Please use
##  UVC_FRAME_FORMAT_* instead of using these.

const
  UVC_COLOR_FORMAT_UNKNOWN* = UVC_FRAME_FORMAT_UNKNOWN
  UVC_COLOR_FORMAT_UNCOMPRESSED* = UVC_FRAME_FORMAT_UNCOMPRESSED
  UVC_COLOR_FORMAT_COMPRESSED* = UVC_FRAME_FORMAT_COMPRESSED
  UVC_COLOR_FORMAT_YUYV* = UVC_FRAME_FORMAT_YUYV
  UVC_COLOR_FORMAT_UYVY* = UVC_FRAME_FORMAT_UYVY
  UVC_COLOR_FORMAT_RGB* = UVC_FRAME_FORMAT_RGB
  UVC_COLOR_FORMAT_BGR* = UVC_FRAME_FORMAT_BGR
  UVC_COLOR_FORMAT_MJPEG* = UVC_FRAME_FORMAT_MJPEG
  UVC_COLOR_FORMAT_GRAY8* = UVC_FRAME_FORMAT_GRAY8
  UVC_COLOR_FORMAT_GRAY16* = UVC_FRAME_FORMAT_GRAY16
  UVC_COLOR_FORMAT_NV12* = UVC_FRAME_FORMAT_NV12

## * VideoStreaming interface descriptor subtype (A.6)

type
  uvc_vs_desc_subtype* = enum
    UVC_VS_UNDEFINED = 0x00, UVC_VS_INPUT_HEADER = 0x01, UVC_VS_OUTPUT_HEADER = 0x02,
    UVC_VS_STILL_IMAGE_FRAME = 0x03, UVC_VS_FORMAT_UNCOMPRESSED = 0x04,
    UVC_VS_FRAME_UNCOMPRESSED = 0x05, UVC_VS_FORMAT_MJPEG = 0x06,
    UVC_VS_FRAME_MJPEG = 0x07, UVC_VS_FORMAT_MPEG2TS = 0x0a, UVC_VS_FORMAT_DV = 0x0c,
    UVC_VS_COLORFORMAT = 0x0d, UVC_VS_FORMAT_FRAME_BASED = 0x10,
    UVC_VS_FRAME_FRAME_BASED = 0x11, UVC_VS_FORMAT_STREAM_BASED = 0x12


discard "forward decl of uvc_format_desc"
discard "forward decl of uvc_frame_desc"
type
  uvc_still_frame_res_t* {.bycopy.} = object
    prev*: ptr uvc_still_frame_res
    next*: ptr uvc_still_frame_res
    bResolutionIndex*: uint8_t ## * Image width
    wWidth*: uint16_t          ## * Image height
    wHeight*: uint16_t

  uvc_still_frame_desc_t* {.bycopy.} = object
    parent*: ptr uvc_format_desc
    prev*: ptr uvc_still_frame_desc
    next*: ptr uvc_still_frame_desc ## * Type of frame, such as JPEG frame or uncompressed frme
    bDescriptorSubtype*: uvc_vs_desc_subtype ## * Index of the frame within the list of specs available for this format
    bEndPointAddress*: uint8_t
    imageSizePatterns*: ptr uvc_still_frame_res_t
    bNumCompressionPattern*: uint8_t ##  indication of compression level, the higher, the more compression is applied to image
    bCompression*: ptr uint8_t


## * Frame descriptor
##
##  A "frame" is a configuration of a streaming format
##  for a particular image size at one of possibly several
##  available frame rates.
##

type
  uvc_frame_desc_t* {.bycopy.} = object
    parent*: ptr uvc_format_desc
    prev*: ptr uvc_frame_desc
    next*: ptr uvc_frame_desc   ## * Type of frame, such as JPEG frame or uncompressed frme
    bDescriptorSubtype*: uvc_vs_desc_subtype ## * Index of the frame within the list of specs available for this format
    bFrameIndex*: uint8_t
    bmCapabilities*: uint8_t   ## * Image width
    wWidth*: uint16_t          ## * Image height
    wHeight*: uint16_t         ## * Bitrate of corresponding stream at minimal frame rate
    dwMinBitRate*: uint32_t    ## * Bitrate of corresponding stream at maximal frame rate
    dwMaxBitRate*: uint32_t    ## * Maximum number of bytes for a video frame
    dwMaxVideoFrameBufferSize*: uint32_t ## * Default frame interval (in 100ns units)
    dwDefaultFrameInterval*: uint32_t ## * Minimum frame interval for continuous mode (100ns units)
    dwMinFrameInterval*: uint32_t ## * Maximum frame interval for continuous mode (100ns units)
    dwMaxFrameInterval*: uint32_t ## * Granularity of frame interval range for continuous mode (100ns)
    dwFrameIntervalStep*: uint32_t ## * Frame intervals
    bFrameIntervalType*: uint8_t ## * number of bytes per line
    dwBytesPerLine*: uint32_t  ## * Available frame rates, zero-terminated (in 100ns units)
    intervals*: ptr uint32_t


## * Format descriptor
##
##  A "format" determines a stream's image type (e.g., raw YUYV or JPEG)
##  and includes many "frame" configurations.
##

type
  INNER_C_UNION_libuvc_234* {.bycopy, union.} = object
    guidFormat*: array[16, uint8_t]
    fourccFormat*: array[4, uint8_t]

  INNER_C_UNION_libuvc_234* {.bycopy, union.} = object
    bBitsPerPixel*: uint8_t    ## * BPP for uncompressed stream
    ## * Flags for JPEG stream
    bmFlags*: uint8_t

  uvc_format_desc_t* {.bycopy.} = object
    parent*: ptr uvc_streaming_interface
    prev*: ptr uvc_format_desc
    next*: ptr uvc_format_desc  ## * Type of image stream, such as JPEG or uncompressed.
    bDescriptorSubtype*: uvc_vs_desc_subtype ## * Identifier of this format within the VS interface's format list
    bFormatIndex*: uint8_t
    bNumFrameDescriptors*: uint8_t ## * Format specifier
    ano_libuvc_234*: INNER_C_UNION_libuvc_234
    ano_libuvc_234*: INNER_C_UNION_libuvc_234
    bDefaultFrameIndex*: uint8_t
    bAspectRatioX*: uint8_t
    bAspectRatioY*: uint8_t
    bmInterlaceFlags*: uint8_t
    bCopyProtect*: uint8_t
    bVariableSize*: uint8_t    ## * Available frame specifications for this format
    frame_descs*: ptr uvc_frame_desc
    still_frame_desc*: ptr uvc_still_frame_desc


## * UVC request code (A.8)

type
  uvc_req_code* = enum
    UVC_RC_UNDEFINED = 0x00, UVC_SET_CUR = 0x01, UVC_GET_CUR = 0x81, UVC_GET_MIN = 0x82,
    UVC_GET_MAX = 0x83, UVC_GET_RES = 0x84, UVC_GET_LEN = 0x85, UVC_GET_INFO = 0x86,
    UVC_GET_DEF = 0x87


type
  uvc_device_power_mode* = enum
    UVC_VC_VIDEO_POWER_MODE_FULL = 0x000b,
    UVC_VC_VIDEO_POWER_MODE_DEVICE_DEPENDENT = 0x001b


## * Camera terminal control selector (A.9.4)

type
  uvc_ct_ctrl_selector* = enum
    UVC_CT_CONTROL_UNDEFINED = 0x00, UVC_CT_SCANNING_MODE_CONTROL = 0x01,
    UVC_CT_AE_MODE_CONTROL = 0x02, UVC_CT_AE_PRIORITY_CONTROL = 0x03,
    UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL = 0x04,
    UVC_CT_EXPOSURE_TIME_RELATIVE_CONTROL = 0x05,
    UVC_CT_FOCUS_ABSOLUTE_CONTROL = 0x06, UVC_CT_FOCUS_RELATIVE_CONTROL = 0x07,
    UVC_CT_FOCUS_AUTO_CONTROL = 0x08, UVC_CT_IRIS_ABSOLUTE_CONTROL = 0x09,
    UVC_CT_IRIS_RELATIVE_CONTROL = 0x0a, UVC_CT_ZOOM_ABSOLUTE_CONTROL = 0x0b,
    UVC_CT_ZOOM_RELATIVE_CONTROL = 0x0c, UVC_CT_PANTILT_ABSOLUTE_CONTROL = 0x0d,
    UVC_CT_PANTILT_RELATIVE_CONTROL = 0x0e, UVC_CT_ROLL_ABSOLUTE_CONTROL = 0x0f,
    UVC_CT_ROLL_RELATIVE_CONTROL = 0x10, UVC_CT_PRIVACY_CONTROL = 0x11,
    UVC_CT_FOCUS_SIMPLE_CONTROL = 0x12, UVC_CT_DIGITAL_WINDOW_CONTROL = 0x13,
    UVC_CT_REGION_OF_INTEREST_CONTROL = 0x14


## * Processing unit control selector (A.9.5)

type
  uvc_pu_ctrl_selector* = enum
    UVC_PU_CONTROL_UNDEFINED = 0x00, UVC_PU_BACKLIGHT_COMPENSATION_CONTROL = 0x01,
    UVC_PU_BRIGHTNESS_CONTROL = 0x02, UVC_PU_CONTRAST_CONTROL = 0x03,
    UVC_PU_GAIN_CONTROL = 0x04, UVC_PU_POWER_LINE_FREQUENCY_CONTROL = 0x05,
    UVC_PU_HUE_CONTROL = 0x06, UVC_PU_SATURATION_CONTROL = 0x07,
    UVC_PU_SHARPNESS_CONTROL = 0x08, UVC_PU_GAMMA_CONTROL = 0x09,
    UVC_PU_WHITE_BALANCE_TEMPERATURE_CONTROL = 0x0a,
    UVC_PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL = 0x0b,
    UVC_PU_WHITE_BALANCE_COMPONENT_CONTROL = 0x0c,
    UVC_PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL = 0x0d,
    UVC_PU_DIGITAL_MULTIPLIER_CONTROL = 0x0e,
    UVC_PU_DIGITAL_MULTIPLIER_LIMIT_CONTROL = 0x0f, UVC_PU_HUE_AUTO_CONTROL = 0x10,
    UVC_PU_ANALOG_VIDEO_STANDARD_CONTROL = 0x11,
    UVC_PU_ANALOG_LOCK_STATUS_CONTROL = 0x12, UVC_PU_CONTRAST_AUTO_CONTROL = 0x13


## * USB terminal type (B.1)

type
  uvc_term_type* = enum
    UVC_TT_VENDOR_SPECIFIC = 0x0100, UVC_TT_STREAMING = 0x0101


## * Input terminal type (B.2)

type
  uvc_it_type* = enum
    UVC_ITT_VENDOR_SPECIFIC = 0x0200, UVC_ITT_CAMERA = 0x0201,
    UVC_ITT_MEDIA_TRANSPORT_INPUT = 0x0202


## * Output terminal type (B.3)

type
  uvc_ot_type* = enum
    UVC_OTT_VENDOR_SPECIFIC = 0x0300, UVC_OTT_DISPLAY = 0x0301,
    UVC_OTT_MEDIA_TRANSPORT_OUTPUT = 0x0302


## * External terminal type (B.4)

type
  uvc_et_type* = enum
    UVC_EXTERNAL_VENDOR_SPECIFIC = 0x0400, UVC_COMPOSITE_CONNECTOR = 0x0401,
    UVC_SVIDEO_CONNECTOR = 0x0402, UVC_COMPONENT_CONNECTOR = 0x0403


## * Context, equivalent to libusb's contexts.
##
##  May either own a libusb context or use one that's already made.
##
##  Always create these with uvc_get_context.
##

discard "forward decl of uvc_context"
type
  uvc_context_t* = uvc_context

## * UVC device.
##
##  Get this from uvc_get_device_list() or uvc_find_device().
##

discard "forward decl of uvc_device"
type
  uvc_device_t* = uvc_device

## * Handle on an open UVC device.
##
##  Get one of these from uvc_open(). Once you uvc_close()
##  it, it's no longer valid.
##

discard "forward decl of uvc_device_handle"
type
  uvc_device_handle_t* = uvc_device_handle

## * Handle on an open UVC stream.
##
##  Get one of these from uvc_stream_open*().
##  Once you uvc_stream_close() it, it will no longer be valid.
##

discard "forward decl of uvc_stream_handle"
type
  uvc_stream_handle_t* = uvc_stream_handle

## * Representation of the interface that brings data into the UVC device

type
  uvc_input_terminal_t* {.bycopy.} = object
    prev*: ptr uvc_input_terminal
    next*: ptr uvc_input_terminal ## * Index of the terminal within the device
    bTerminalID*: uint8_t      ## * Type of terminal (e.g., camera)
    wTerminalType*: uvc_it_type
    wObjectiveFocalLengthMin*: uint16_t
    wObjectiveFocalLengthMax*: uint16_t
    wOcularFocalLength*: uint16_t ## * Camera controls (meaning of bits given in {uvc_ct_ctrl_selector})
    bmControls*: uint64_t

  uvc_output_terminal_t* {.bycopy.} = object
    prev*: ptr uvc_output_terminal
    next*: ptr uvc_output_terminal ## * @todo


## * Represents post-capture processing functions

type
  uvc_processing_unit_t* {.bycopy.} = object
    prev*: ptr uvc_processing_unit
    next*: ptr uvc_processing_unit ## * Index of the processing unit within the device
    bUnitID*: uint8_t          ## * Index of the terminal from which the device accepts images
    bSourceID*: uint8_t        ## * Processing controls (meaning of bits given in {uvc_pu_ctrl_selector})
    bmControls*: uint64_t


## * Represents selector unit to connect other units

type
  uvc_selector_unit_t* {.bycopy.} = object
    prev*: ptr uvc_selector_unit
    next*: ptr uvc_selector_unit ## * Index of the selector unit within the device
    bUnitID*: uint8_t


## * Custom processing or camera-control functions

type
  uvc_extension_unit_t* {.bycopy.} = object
    prev*: ptr uvc_extension_unit
    next*: ptr uvc_extension_unit ## * Index of the extension unit within the device
    bUnitID*: uint8_t          ## * GUID identifying the extension unit
    guidExtensionCode*: array[16, uint8_t] ## * Bitmap of available controls (manufacturer-dependent)
    bmControls*: uint64_t

  uvc_status_class* = enum
    UVC_STATUS_CLASS_CONTROL = 0x10, UVC_STATUS_CLASS_CONTROL_CAMERA = 0x11,
    UVC_STATUS_CLASS_CONTROL_PROCESSING = 0x12


type
  uvc_status_attribute* = enum
    UVC_STATUS_ATTRIBUTE_VALUE_CHANGE = 0x00,
    UVC_STATUS_ATTRIBUTE_INFO_CHANGE = 0x01,
    UVC_STATUS_ATTRIBUTE_FAILURE_CHANGE = 0x02, UVC_STATUS_ATTRIBUTE_UNKNOWN = 0xff


## * A callback function to accept status updates
##  @ingroup device
##

type
  uvc_status_callback_t* = proc (status_class: uvc_status_class; event: cint;
                              selector: cint;
                              status_attribute: uvc_status_attribute;
                              data: pointer; data_len: csize_t; user_ptr: pointer)

## * A callback function to accept button events
##  @ingroup device
##

type
  uvc_button_callback_t* = proc (button: cint; state: cint; user_ptr: pointer)

## * Structure representing a UVC device descriptor.
##
##  (This isn't a standard structure.)
##

type
  uvc_device_descriptor_t* {.bycopy.} = object
    idVendor*: uint16_t        ## * Vendor ID
    ## * Product ID
    idProduct*: uint16_t       ## * UVC compliance level, e.g. 0x0100 (1.0), 0x0110
    bcdUVC*: uint16_t          ## * Serial number (null if unavailable)
    serialNumber*: cstring     ## * Device-reported manufacturer name (or null)
    manufacturer*: cstring     ## * Device-reporter product name (or null)
    product*: cstring


## * An image frame received from the UVC device
##  @ingroup streaming
##

type
  uvc_frame_t* {.bycopy.} = object
    data*: pointer             ## * Image data for this frame
    ## * Size of image data buffer
    data_bytes*: csize_t       ## * Width of image in pixels
    width*: uint32_t           ## * Height of image in pixels
    height*: uint32_t          ## * Pixel data format
    frame_format*: uvc_frame_format ## * Number of bytes per horizontal line (undefined for compressed format)
    step*: csize_t             ## * Frame number (may skip, but is strictly monotonically increasing)
    sequence*: uint32_t        ## * Estimate of system time when the device started capturing the image
    capture_time*: timeval     ## * Estimate of system time when the device finished receiving the image
    capture_time_finished*: timespec ## * Handle on the device that produced the image.
                                   ##  @warning You must not call any uvc_* functions during a callback.
    source*: ptr uvc_device_handle_t ## * Is the data buffer owned by the library?
                                  ##  If 1, the data buffer can be arbitrarily reallocated by frame conversion
                                  ##  functions.
                                  ##  If 0, the data buffer will not be reallocated or freed by the library.
                                  ##  Set this field to zero if you are supplying the buffer.
                                  ##
    library_owns_data*: uint8_t ## * Metadata for this frame if available
    metadata*: pointer         ## * Size of metadata buffer
    metadata_bytes*: csize_t


## * A callback function to handle incoming assembled UVC frames
##  @ingroup streaming
##

type
  uvc_frame_callback_t* = proc (frame: ptr uvc_frame; user_ptr: pointer)

## * Streaming mode, includes all information needed to select stream
##  @ingroup streaming
##

type
  uvc_stream_ctrl_t* {.bycopy.} = object
    bmHint*: uint16_t
    bFormatIndex*: uint8_t
    bFrameIndex*: uint8_t
    dwFrameInterval*: uint32_t
    wKeyFrameRate*: uint16_t
    wPFrameRate*: uint16_t
    wCompQuality*: uint16_t
    wCompWindowSize*: uint16_t
    wDelay*: uint16_t
    dwMaxVideoFrameSize*: uint32_t
    dwMaxPayloadTransferSize*: uint32_t
    dwClockFrequency*: uint32_t
    bmFramingInfo*: uint8_t
    bPreferredVersion*: uint8_t
    bMinVersion*: uint8_t
    bMaxVersion*: uint8_t
    bInterfaceNumber*: uint8_t

  uvc_still_ctrl_t* {.bycopy.} = object
    bFormatIndex*: uint8_t     ##  Video format index from a format descriptor
    ##  Video frame index from a frame descriptor
    bFrameIndex*: uint8_t      ##  Compression index from a frame descriptor
    bCompressionIndex*: uint8_t ##  Maximum still image size in bytes.
    dwMaxVideoFrameSize*: uint32_t ##  Maximum number of byte per payload
    dwMaxPayloadTransferSize*: uint32_t
    bInterfaceNumber*: uint8_t


proc uvc_init*(ctx: ptr ptr uvc_context_t; usb_ctx: ptr libusb_context): uvc_error_t
proc uvc_exit*(ctx: ptr uvc_context_t)
proc uvc_get_device_list*(ctx: ptr uvc_context_t; list: ptr ptr ptr uvc_device_t): uvc_error_t
proc uvc_free_device_list*(list: ptr ptr uvc_device_t; unref_devices: uint8_t)
proc uvc_get_device_descriptor*(dev: ptr uvc_device_t;
                               desc: ptr ptr uvc_device_descriptor_t): uvc_error_t
proc uvc_free_device_descriptor*(desc: ptr uvc_device_descriptor_t)
proc uvc_get_bus_number*(dev: ptr uvc_device_t): uint8_t
proc uvc_get_device_address*(dev: ptr uvc_device_t): uint8_t
proc uvc_find_device*(ctx: ptr uvc_context_t; dev: ptr ptr uvc_device_t; vid: cint;
                     pid: cint; sn: cstring): uvc_error_t
proc uvc_find_devices*(ctx: ptr uvc_context_t; devs: ptr ptr ptr uvc_device_t; vid: cint;
                      pid: cint; sn: cstring): uvc_error_t
when LIBUSB_API_VERSION >= 0x01000107:
  proc uvc_wrap*(sys_dev: cint; context: ptr uvc_context_t;
                devh: ptr ptr uvc_device_handle_t): uvc_error_t
proc uvc_open*(dev: ptr uvc_device_t; devh: ptr ptr uvc_device_handle_t): uvc_error_t
proc uvc_close*(devh: ptr uvc_device_handle_t)
proc uvc_get_device*(devh: ptr uvc_device_handle_t): ptr uvc_device_t
proc uvc_get_libusb_handle*(devh: ptr uvc_device_handle_t): ptr libusb_device_handle
proc uvc_ref_device*(dev: ptr uvc_device_t)
proc uvc_unref_device*(dev: ptr uvc_device_t)
proc uvc_set_status_callback*(devh: ptr uvc_device_handle_t;
                             cb: uvc_status_callback_t; user_ptr: pointer)
proc uvc_set_button_callback*(devh: ptr uvc_device_handle_t;
                             cb: uvc_button_callback_t; user_ptr: pointer)
proc uvc_get_camera_terminal*(devh: ptr uvc_device_handle_t): ptr uvc_input_terminal_t
proc uvc_get_input_terminals*(devh: ptr uvc_device_handle_t): ptr uvc_input_terminal_t
proc uvc_get_output_terminals*(devh: ptr uvc_device_handle_t): ptr uvc_output_terminal_t
proc uvc_get_selector_units*(devh: ptr uvc_device_handle_t): ptr uvc_selector_unit_t
proc uvc_get_processing_units*(devh: ptr uvc_device_handle_t): ptr uvc_processing_unit_t
proc uvc_get_extension_units*(devh: ptr uvc_device_handle_t): ptr uvc_extension_unit_t
proc uvc_get_stream_ctrl_format_size*(devh: ptr uvc_device_handle_t;
                                     ctrl: ptr uvc_stream_ctrl_t;
                                     format: uvc_frame_format; width: cint;
                                     height: cint; fps: cint): uvc_error_t
proc uvc_get_still_ctrl_format_size*(devh: ptr uvc_device_handle_t;
                                    ctrl: ptr uvc_stream_ctrl_t;
                                    still_ctrl: ptr uvc_still_ctrl_t; width: cint;
                                    height: cint): uvc_error_t
proc uvc_trigger_still*(devh: ptr uvc_device_handle_t;
                       still_ctrl: ptr uvc_still_ctrl_t): uvc_error_t
proc uvc_get_format_descs*(a1: ptr uvc_device_handle_t): ptr uvc_format_desc_t
proc uvc_probe_stream_ctrl*(devh: ptr uvc_device_handle_t;
                           ctrl: ptr uvc_stream_ctrl_t): uvc_error_t
proc uvc_probe_still_ctrl*(devh: ptr uvc_device_handle_t;
                          still_ctrl: ptr uvc_still_ctrl_t): uvc_error_t
proc uvc_start_streaming*(devh: ptr uvc_device_handle_t;
                         ctrl: ptr uvc_stream_ctrl_t; cb: ptr uvc_frame_callback_t;
                         user_ptr: pointer; flags: uint8_t): uvc_error_t
proc uvc_start_iso_streaming*(devh: ptr uvc_device_handle_t;
                             ctrl: ptr uvc_stream_ctrl_t;
                             cb: ptr uvc_frame_callback_t; user_ptr: pointer): uvc_error_t
proc uvc_stop_streaming*(devh: ptr uvc_device_handle_t)
proc uvc_stream_open_ctrl*(devh: ptr uvc_device_handle_t;
                          strmh: ptr ptr uvc_stream_handle_t;
                          ctrl: ptr uvc_stream_ctrl_t): uvc_error_t
proc uvc_stream_ctrl*(strmh: ptr uvc_stream_handle_t; ctrl: ptr uvc_stream_ctrl_t): uvc_error_t
proc uvc_stream_start*(strmh: ptr uvc_stream_handle_t; cb: ptr uvc_frame_callback_t;
                      user_ptr: pointer; flags: uint8_t): uvc_error_t
proc uvc_stream_start_iso*(strmh: ptr uvc_stream_handle_t;
                          cb: ptr uvc_frame_callback_t; user_ptr: pointer): uvc_error_t
proc uvc_stream_get_frame*(strmh: ptr uvc_stream_handle_t;
                          frame: ptr ptr uvc_frame_t; timeout_us: int32_t): uvc_error_t
proc uvc_stream_stop*(strmh: ptr uvc_stream_handle_t): uvc_error_t
proc uvc_stream_close*(strmh: ptr uvc_stream_handle_t)
proc uvc_get_ctrl_len*(devh: ptr uvc_device_handle_t; unit: uint8_t; ctrl: uint8_t): cint
proc uvc_get_ctrl*(devh: ptr uvc_device_handle_t; unit: uint8_t; ctrl: uint8_t;
                  data: pointer; len: cint; req_code: uvc_req_code): cint
proc uvc_set_ctrl*(devh: ptr uvc_device_handle_t; unit: uint8_t; ctrl: uint8_t;
                  data: pointer; len: cint): cint
proc uvc_get_power_mode*(devh: ptr uvc_device_handle_t;
                        mode: ptr uvc_device_power_mode; req_code: uvc_req_code): uvc_error_t
proc uvc_set_power_mode*(devh: ptr uvc_device_handle_t; mode: uvc_device_power_mode): uvc_error_t
##  AUTO-GENERATED control accessors! Update them with the output of `ctrl-gen.py decl`.

proc uvc_get_scanning_mode*(devh: ptr uvc_device_handle_t; mode: ptr uint8_t;
                           req_code: uvc_req_code): uvc_error_t
proc uvc_set_scanning_mode*(devh: ptr uvc_device_handle_t; mode: uint8_t): uvc_error_t
proc uvc_get_ae_mode*(devh: ptr uvc_device_handle_t; mode: ptr uint8_t;
                     req_code: uvc_req_code): uvc_error_t
proc uvc_set_ae_mode*(devh: ptr uvc_device_handle_t; mode: uint8_t): uvc_error_t
proc uvc_get_ae_priority*(devh: ptr uvc_device_handle_t; priority: ptr uint8_t;
                         req_code: uvc_req_code): uvc_error_t
proc uvc_set_ae_priority*(devh: ptr uvc_device_handle_t; priority: uint8_t): uvc_error_t
proc uvc_get_exposure_abs*(devh: ptr uvc_device_handle_t; time: ptr uint32_t;
                          req_code: uvc_req_code): uvc_error_t
proc uvc_set_exposure_abs*(devh: ptr uvc_device_handle_t; time: uint32_t): uvc_error_t
proc uvc_get_exposure_rel*(devh: ptr uvc_device_handle_t; step: ptr int8_t;
                          req_code: uvc_req_code): uvc_error_t
proc uvc_set_exposure_rel*(devh: ptr uvc_device_handle_t; step: int8_t): uvc_error_t
proc uvc_get_focus_abs*(devh: ptr uvc_device_handle_t; focus: ptr uint16_t;
                       req_code: uvc_req_code): uvc_error_t
proc uvc_set_focus_abs*(devh: ptr uvc_device_handle_t; focus: uint16_t): uvc_error_t
proc uvc_get_focus_rel*(devh: ptr uvc_device_handle_t; focus_rel: ptr int8_t;
                       speed: ptr uint8_t; req_code: uvc_req_code): uvc_error_t
proc uvc_set_focus_rel*(devh: ptr uvc_device_handle_t; focus_rel: int8_t;
                       speed: uint8_t): uvc_error_t
proc uvc_get_focus_simple_range*(devh: ptr uvc_device_handle_t; focus: ptr uint8_t;
                                req_code: uvc_req_code): uvc_error_t
proc uvc_set_focus_simple_range*(devh: ptr uvc_device_handle_t; focus: uint8_t): uvc_error_t
proc uvc_get_focus_auto*(devh: ptr uvc_device_handle_t; state: ptr uint8_t;
                        req_code: uvc_req_code): uvc_error_t
proc uvc_set_focus_auto*(devh: ptr uvc_device_handle_t; state: uint8_t): uvc_error_t
proc uvc_get_iris_abs*(devh: ptr uvc_device_handle_t; iris: ptr uint16_t;
                      req_code: uvc_req_code): uvc_error_t
proc uvc_set_iris_abs*(devh: ptr uvc_device_handle_t; iris: uint16_t): uvc_error_t
proc uvc_get_iris_rel*(devh: ptr uvc_device_handle_t; iris_rel: ptr uint8_t;
                      req_code: uvc_req_code): uvc_error_t
proc uvc_set_iris_rel*(devh: ptr uvc_device_handle_t; iris_rel: uint8_t): uvc_error_t
proc uvc_get_zoom_abs*(devh: ptr uvc_device_handle_t; focal_length: ptr uint16_t;
                      req_code: uvc_req_code): uvc_error_t
proc uvc_set_zoom_abs*(devh: ptr uvc_device_handle_t; focal_length: uint16_t): uvc_error_t
proc uvc_get_zoom_rel*(devh: ptr uvc_device_handle_t; zoom_rel: ptr int8_t;
                      digital_zoom: ptr uint8_t; speed: ptr uint8_t;
                      req_code: uvc_req_code): uvc_error_t
proc uvc_set_zoom_rel*(devh: ptr uvc_device_handle_t; zoom_rel: int8_t;
                      digital_zoom: uint8_t; speed: uint8_t): uvc_error_t
proc uvc_get_pantilt_abs*(devh: ptr uvc_device_handle_t; pan: ptr int32_t;
                         tilt: ptr int32_t; req_code: uvc_req_code): uvc_error_t
proc uvc_set_pantilt_abs*(devh: ptr uvc_device_handle_t; pan: int32_t; tilt: int32_t): uvc_error_t
proc uvc_get_pantilt_rel*(devh: ptr uvc_device_handle_t; pan_rel: ptr int8_t;
                         pan_speed: ptr uint8_t; tilt_rel: ptr int8_t;
                         tilt_speed: ptr uint8_t; req_code: uvc_req_code): uvc_error_t
proc uvc_set_pantilt_rel*(devh: ptr uvc_device_handle_t; pan_rel: int8_t;
                         pan_speed: uint8_t; tilt_rel: int8_t; tilt_speed: uint8_t): uvc_error_t
proc uvc_get_roll_abs*(devh: ptr uvc_device_handle_t; roll: ptr int16_t;
                      req_code: uvc_req_code): uvc_error_t
proc uvc_set_roll_abs*(devh: ptr uvc_device_handle_t; roll: int16_t): uvc_error_t
proc uvc_get_roll_rel*(devh: ptr uvc_device_handle_t; roll_rel: ptr int8_t;
                      speed: ptr uint8_t; req_code: uvc_req_code): uvc_error_t
proc uvc_set_roll_rel*(devh: ptr uvc_device_handle_t; roll_rel: int8_t; speed: uint8_t): uvc_error_t
proc uvc_get_privacy*(devh: ptr uvc_device_handle_t; privacy: ptr uint8_t;
                     req_code: uvc_req_code): uvc_error_t
proc uvc_set_privacy*(devh: ptr uvc_device_handle_t; privacy: uint8_t): uvc_error_t
proc uvc_get_digital_window*(devh: ptr uvc_device_handle_t;
                            window_top: ptr uint16_t; window_left: ptr uint16_t;
                            window_bottom: ptr uint16_t;
                            window_right: ptr uint16_t; num_steps: ptr uint16_t;
                            num_steps_units: ptr uint16_t; req_code: uvc_req_code): uvc_error_t
proc uvc_set_digital_window*(devh: ptr uvc_device_handle_t; window_top: uint16_t;
                            window_left: uint16_t; window_bottom: uint16_t;
                            window_right: uint16_t; num_steps: uint16_t;
                            num_steps_units: uint16_t): uvc_error_t
proc uvc_get_digital_roi*(devh: ptr uvc_device_handle_t; roi_top: ptr uint16_t;
                         roi_left: ptr uint16_t; roi_bottom: ptr uint16_t;
                         roi_right: ptr uint16_t; auto_controls: ptr uint16_t;
                         req_code: uvc_req_code): uvc_error_t
proc uvc_set_digital_roi*(devh: ptr uvc_device_handle_t; roi_top: uint16_t;
                         roi_left: uint16_t; roi_bottom: uint16_t;
                         roi_right: uint16_t; auto_controls: uint16_t): uvc_error_t
proc uvc_get_backlight_compensation*(devh: ptr uvc_device_handle_t;
                                    backlight_compensation: ptr uint16_t;
                                    req_code: uvc_req_code): uvc_error_t
proc uvc_set_backlight_compensation*(devh: ptr uvc_device_handle_t;
                                    backlight_compensation: uint16_t): uvc_error_t
proc uvc_get_brightness*(devh: ptr uvc_device_handle_t; brightness: ptr int16_t;
                        req_code: uvc_req_code): uvc_error_t
proc uvc_set_brightness*(devh: ptr uvc_device_handle_t; brightness: int16_t): uvc_error_t
proc uvc_get_contrast*(devh: ptr uvc_device_handle_t; contrast: ptr uint16_t;
                      req_code: uvc_req_code): uvc_error_t
proc uvc_set_contrast*(devh: ptr uvc_device_handle_t; contrast: uint16_t): uvc_error_t
proc uvc_get_contrast_auto*(devh: ptr uvc_device_handle_t;
                           contrast_auto: ptr uint8_t; req_code: uvc_req_code): uvc_error_t
proc uvc_set_contrast_auto*(devh: ptr uvc_device_handle_t; contrast_auto: uint8_t): uvc_error_t
proc uvc_get_gain*(devh: ptr uvc_device_handle_t; gain: ptr uint16_t;
                  req_code: uvc_req_code): uvc_error_t
proc uvc_set_gain*(devh: ptr uvc_device_handle_t; gain: uint16_t): uvc_error_t
proc uvc_get_power_line_frequency*(devh: ptr uvc_device_handle_t;
                                  power_line_frequency: ptr uint8_t;
                                  req_code: uvc_req_code): uvc_error_t
proc uvc_set_power_line_frequency*(devh: ptr uvc_device_handle_t;
                                  power_line_frequency: uint8_t): uvc_error_t
proc uvc_get_hue*(devh: ptr uvc_device_handle_t; hue: ptr int16_t;
                 req_code: uvc_req_code): uvc_error_t
proc uvc_set_hue*(devh: ptr uvc_device_handle_t; hue: int16_t): uvc_error_t
proc uvc_get_hue_auto*(devh: ptr uvc_device_handle_t; hue_auto: ptr uint8_t;
                      req_code: uvc_req_code): uvc_error_t
proc uvc_set_hue_auto*(devh: ptr uvc_device_handle_t; hue_auto: uint8_t): uvc_error_t
proc uvc_get_saturation*(devh: ptr uvc_device_handle_t; saturation: ptr uint16_t;
                        req_code: uvc_req_code): uvc_error_t
proc uvc_set_saturation*(devh: ptr uvc_device_handle_t; saturation: uint16_t): uvc_error_t
proc uvc_get_sharpness*(devh: ptr uvc_device_handle_t; sharpness: ptr uint16_t;
                       req_code: uvc_req_code): uvc_error_t
proc uvc_set_sharpness*(devh: ptr uvc_device_handle_t; sharpness: uint16_t): uvc_error_t
proc uvc_get_gamma*(devh: ptr uvc_device_handle_t; gamma: ptr uint16_t;
                   req_code: uvc_req_code): uvc_error_t
proc uvc_set_gamma*(devh: ptr uvc_device_handle_t; gamma: uint16_t): uvc_error_t
proc uvc_get_white_balance_temperature*(devh: ptr uvc_device_handle_t;
                                       temperature: ptr uint16_t;
                                       req_code: uvc_req_code): uvc_error_t
proc uvc_set_white_balance_temperature*(devh: ptr uvc_device_handle_t;
                                       temperature: uint16_t): uvc_error_t
proc uvc_get_white_balance_temperature_auto*(devh: ptr uvc_device_handle_t;
    temperature_auto: ptr uint8_t; req_code: uvc_req_code): uvc_error_t
proc uvc_set_white_balance_temperature_auto*(devh: ptr uvc_device_handle_t;
    temperature_auto: uint8_t): uvc_error_t
proc uvc_get_white_balance_component*(devh: ptr uvc_device_handle_t;
                                     blue: ptr uint16_t; red: ptr uint16_t;
                                     req_code: uvc_req_code): uvc_error_t
proc uvc_set_white_balance_component*(devh: ptr uvc_device_handle_t; blue: uint16_t;
                                     red: uint16_t): uvc_error_t
proc uvc_get_white_balance_component_auto*(devh: ptr uvc_device_handle_t;
    white_balance_component_auto: ptr uint8_t; req_code: uvc_req_code): uvc_error_t
proc uvc_set_white_balance_component_auto*(devh: ptr uvc_device_handle_t;
    white_balance_component_auto: uint8_t): uvc_error_t
proc uvc_get_digital_multiplier*(devh: ptr uvc_device_handle_t;
                                multiplier_step: ptr uint16_t;
                                req_code: uvc_req_code): uvc_error_t
proc uvc_set_digital_multiplier*(devh: ptr uvc_device_handle_t;
                                multiplier_step: uint16_t): uvc_error_t
proc uvc_get_digital_multiplier_limit*(devh: ptr uvc_device_handle_t;
                                      multiplier_step: ptr uint16_t;
                                      req_code: uvc_req_code): uvc_error_t
proc uvc_set_digital_multiplier_limit*(devh: ptr uvc_device_handle_t;
                                      multiplier_step: uint16_t): uvc_error_t
proc uvc_get_analog_video_standard*(devh: ptr uvc_device_handle_t;
                                   video_standard: ptr uint8_t;
                                   req_code: uvc_req_code): uvc_error_t
proc uvc_set_analog_video_standard*(devh: ptr uvc_device_handle_t;
                                   video_standard: uint8_t): uvc_error_t
proc uvc_get_analog_video_lock_status*(devh: ptr uvc_device_handle_t;
                                      status: ptr uint8_t; req_code: uvc_req_code): uvc_error_t
proc uvc_set_analog_video_lock_status*(devh: ptr uvc_device_handle_t;
                                      status: uint8_t): uvc_error_t
proc uvc_get_input_select*(devh: ptr uvc_device_handle_t; selector: ptr uint8_t;
                          req_code: uvc_req_code): uvc_error_t
proc uvc_set_input_select*(devh: ptr uvc_device_handle_t; selector: uint8_t): uvc_error_t
##  end AUTO-GENERATED control accessors

proc uvc_perror*(err: uvc_error_t; msg: cstring)
proc uvc_strerror*(err: uvc_error_t): cstring
proc uvc_print_diag*(devh: ptr uvc_device_handle_t; stream: ptr FILE)
proc uvc_print_stream_ctrl*(ctrl: ptr uvc_stream_ctrl_t; stream: ptr FILE)
proc uvc_allocate_frame*(data_bytes: csize_t): ptr uvc_frame_t
proc uvc_free_frame*(frame: ptr uvc_frame_t)
proc uvc_duplicate_frame*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t
proc uvc_yuyv2rgb*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t
proc uvc_uyvy2rgb*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t
proc uvc_any2rgb*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t
proc uvc_yuyv2bgr*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t
proc uvc_uyvy2bgr*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t
proc uvc_any2bgr*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t
proc uvc_yuyv2y*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t
proc uvc_yuyv2uv*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t
when defined(LIBUVC_HAS_JPEG):
  proc uvc_mjpeg2rgb*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t
  proc uvc_mjpeg2gray*(`in`: ptr uvc_frame_t; `out`: ptr uvc_frame_t): uvc_error_t