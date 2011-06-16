--
--  Primary library for Interfacing with hiredis
--

with Interfaces.C,
     Interfaces.C.Strings,
     System;

package Redis is
    use Interfaces.C;
    use System;

    subtype Port_Type is Natural range 1 .. 65536;

    type Connection is tagged private;

    procedure Set (C : Connection; Key : in String; Value : in String);

    procedure Incr (C : Connection; Key : in String);
    procedure Increment (C : Connection; Key : in String);
    procedure IncrBy (C : Connection; Key : in String; Value : in Integer);
    procedure Increment_By (C : Connection; Key : in String; Value : in Integer);

    procedure Connect (Host : in String; Port : in Port_Type; Conn : out Connection);

private
    package Hiredis is
        REDIS_ERR : constant := -1;
        REDIS_OK : constant := 0;

        -- Error in read or write
        REDIS_ERR_IO : constant := 1;
        -- End of file
        REDIS_ERR_EOF : constant := 3;
        -- Protocol  error
        REDIS_ERR_PROTOCOL : constant := 4;
        -- Out of memory
        REDIS_ERR_OOM : constant := 5;
        -- Everything else
        REDIS_ERR_OTHER : constant := 2;

        -- Connection type can be blocking or non-blocking and is set in the least
        -- significant bit of the flags field in redisContext
        REDIS_BLOCK : constant := 16#1#;
        -- Connection may be disconnected before being free'd. The second bit of
        -- the flags field is set when the context is connected
        REDIS_CONNECTED : constant := 16#2#;
        -- The async API might try to disconnect cleanly and flush the output
        -- buffer and read all subsequent replies before disconnecting. This flag
        -- means now new commands can come in and the connection should be
        -- terminated once all replies have been read
        REDIS_DISCONNECTING : constant := 16#4#;
        -- Flag specific t othe async API which means that the context should be
        -- cleaned up as soon as possible
        REDIS_FREEING : constant := 16#8#;
        -- Flag that is set when an async callback is executed
        REDIS_IN_CALLBACK : constant := 16#10#;
        -- Flag that is set when the async context has one or more subscriptions
        REDIS_SUBSCRIBED : constant := 16#20#;

        REDIS_REPLY_STRING : constant := 1;
        REDIS_REPLY_ARRAY : constant := 2;
        REDIS_REPLY_IntEGER : constant := 3;
        REDIS_REPLY_NIL : constant := 4;
        REDIS_REPLY_STATUS : constant := 5;
        REDIS_REPLY_ERROR : constant := 6;



        subtype Size_Type is Unsigned_Long;
        subtype Redis_Error_Str is Char_Array (0 .. 127);

        type Timeval is record
            tv_sec : aliased Long;
            tv_usec : aliased Long;
        end record;
        pragma Convention (C_Pass_By_Copy, Timeval);

        type redisReply is record
            c_type : aliased Int;
            Integer : aliased Long_Long_Integer;
            len : aliased Int;
            str : Interfaces.C.Strings.chars_ptr;
            elements : aliased Size_Type;
            element : System.Address;
        end record;
        pragma Convention (C_Pass_By_Copy, redisReply);

        type redisReadTask is record
            poff : aliased Size_Type;
            plen : aliased Size_Type;
            coff : aliased Size_Type;
            clen : aliased Size_Type;
            c_type : aliased Int;
            elements : aliased Int;
            idx : aliased Int;
            obj : System.Address;
            parent : access redisReadTask;
            privdata : System.Address;
        end record;
        pragma Convention (C_Pass_By_Copy, redisReadTask);

        type redisTaskStack is array (0 .. 2) of aliased redisReadTask;

        type redisReplyObjectFunctions is record
            createString : access function
                (arg1 : access constant redisReadTask;
                arg2 : Interfaces.C.Strings.chars_ptr;
                arg3 : Size_Type) return System.Address;

            createArray : access function
                (arg1 : access constant redisReadTask;
                arg2 : Int) return System.Address;

            createInteger : access function
                (arg1: access constant redisReadTask;
                arg2 : Long_Long_Integer) return System.Address;

            createNil : access function
                (arg1 : access constant redisReadTask) return System.Address;

            freeObject : access procedure
                (arg1 : System.Address);
        end record;
        pragma Convention (C_Pass_By_Copy, redisReplyObjectFunctions);

        type redisReader is record
            err : aliased Int;
            errstr : aliased Redis_Error_Str;
            buf : Interfaces.C.Strings.Chars_Ptr;
            pos : aliased Size_Type;
            len : aliased Size_Type;
            roff : aliased Size_Type;
            rstack : aliased redisTaskStack;
            ridx : aliased Int;
            reply : System.Address;
            fn : access redisReplyObjectFunctions;
            privdata : System.Address;
        end record;
        pragma Convention (C_Pass_By_Copy, redisReader);

        type redisContext is record
            err : aliased Int;
            errstr : aliased Redis_Error_Str;
            fd : aliased Int;
            flags : aliased Int;
            obuf : Interfaces.C.Strings.Chars_Ptr;
            reader : access redisReader;
        end record;
        pragma Convention (C_Pass_By_Copy, redisContext);


        function redisConnect (Host_Mask : Interfaces.C.Strings.Chars_Ptr;
                               Port : Int) return access redisContext;
        pragma Import (C, redisConnect, "redisConnect");

        function redisConnectWithTimeout (Host_Mask : Interfaces.C.Strings.Chars_Ptr;
                                          Port : Int;
                                          Timeout : Timeval) return access redisContext;
        pragma Import (C, redisConnectWithTimeout, "redisConnectWithTimeout");

        function redisConnectNonBlock (Host_Mask : Interfaces.C.Strings.Chars_Ptr;
                                       Timeout : Int) return access redisContext;
        pragma Import (C, redisConnectNonBlock, "redisConnectNonBlock");

        function redisConnectUnix (Unix_Sock : Interfaces.C.Strings.Chars_Ptr) return access redisContext;
        pragma Import (C, redisConnectUnix, "redisConnectUnix");

        function redisConnectUnixWithTimeout (Unix_Sock: Interfaces.C.Strings.Chars_Ptr;
                                              Timeout: Timeval) return access redisContext;
        pragma Import (C, redisConnectUnixWithTimeout, "redisConnectUnixWithTimeout");

        function redisConnectUnixNonBlock (Unix_Sock : Interfaces.C.Strings.Chars_Ptr) return access redisContext;
        pragma Import (C, redisConnectUnixNonBlock, "redisConnectUnixNonBlock");

        function redisSetTimeout (Context : access redisContext;
                                  Timeout : Timeval) return Int;
        pragma Import (C, redisSetTimeout, "redisSetTimeout");

        procedure redisFree (Context : access redisContext);
        pragma Import (C, redisFree, "redisFree");

        function redisCommandArgv (Context : access redisContext;
            Arg_Count : Int;
            Argv : access Interfaces.C.Strings.Chars_Ptr;
            Argv_Length : access Size_Type) return System.Address;
        pragma Import (C, redisCommandArgv, "redisCommandArgv");
    end Hiredis;

    type Connection is tagged record
        Context : access Hiredis.redisContext;
    end record;
end Redis;
