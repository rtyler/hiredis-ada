--
--
--

with Ada.Text_IO,
     Redis.Shim,
     System;

package body Redis is
    procedure Set (Key : in String; Value : in String) is
        use Ada.Text_IO,
            Interfaces.C;

        Context : access Hiredis.redisContext;
        Host_Ptr : aliased Interfaces.C.Strings.Chars_Ptr := Interfaces.C.Strings.New_String ("localhost");
        Key_Ptr : aliased Interfaces.C.Strings.Chars_Ptr := Interfaces.C.Strings.New_String ("simplekey");
        Value_Ptr : aliased Interfaces.C.Strings.Chars_Ptr := Interfaces.C.Strings.New_String ("simplevalue");
        Unused : System.Address;
    begin
        Put_Line ("Redis.Set");

        Context := Hiredis.redisConnect (Host_Ptr, 6379);
        Unused := Redis.Shim.SET (Context, Key_Ptr, Value_Ptr);

        -- Interfaces.C.Strings.Free (Host_Ptr);
        -- Interfaces.C.Strings.Free (Command_Ptr);
    end Set;
end Redis;
