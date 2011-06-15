#include "../hiredis/hiredis.h"



#define KV_CMD(cmd) void *wrapped##cmd(redisContext *c,\
                                       char *key,\
                                       char *value) {\
                        return redisCommand(c, #cmd " %b %b", key, strlen(key), value, strlen(value));\
}


KV_CMD(SET);
