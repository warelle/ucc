#define va_arg(ap, type)   *(type*)(ap+=sizeof(type))
#define va_start(ap, arg)  (ap)=&(arg)
#define va_end(ap)         ((void) 0)
typedef char *va_list;