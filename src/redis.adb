--
--
--

with Ada.Text_IO,
     System;

package body Redis is
    use Ada.Text_IO,
        Interfaces.C,
        Interfaces.C.Strings;

    procedure Connect (Host : in String; Port : in Port_Type; Conn : out Connection) is
        Host_Ptr : aliased Chars_Ptr := New_String (Host);
    begin
        Conn.Context := Hiredis.redisConnect (Host_Ptr, Int (Port));
        Free (Host_Ptr);
    end Connect;

    procedure Set (C : in Redis.Connection; Key : in String; Value : in String) is
        Unused : System.Address;
        Argv : array (0 .. 2) of aliased Chars_Ptr;
    begin
        Argv (0) := New_String ("SET");
        Argv (1) := New_String (Key);
        Argv (2) := New_String (Value);

        Unused := Hiredis.redisCommandArgv (C.Context, Argv'Length, Argv (0)'Access, null);

        for Index in Argv'Range loop
            Free (Argv (Index));
        end loop;
    end Set;

    procedure Incr (C : Connection; Key : in String) is
    begin
        Increment (C, Key);
    end Incr;

    procedure Increment (C : Connection; Key : in String) is
        Unused : System.Address;
        Argv : array (0 .. 1) of aliased Chars_Ptr;
    begin
        Argv (0) := New_String ("INCR");
        Argv (1) := New_String (Key);

        Unused := Hiredis.redisCommandArgv (C.Context, Argv'Length, Argv (0)'Access, null);

        for Index in Argv'Range loop
            Free (Argv (Index));
        end loop;
    end Increment;

    procedure IncrBy (C : Connection; Key : in String; Value : in Integer) is
    begin
        Increment_By (C, Key, Value);
    end IncrBy;

    procedure Increment_By (C : Connection; Key : in String; Value : in Integer) is
        Unused : System.Address;
        Argv : array (0 .. 2) of aliased Chars_Ptr;
    begin
        Argv (0) := New_String ("INCRBY");
        Argv (1) := New_String (Key);
        Argv (2) := New_String (Integer'Image (Value));

        Unused := Hiredis.redisCommandArgv (C.Context, Argv'Length, Argv (0)'Access, null);

        for Index in Argv'Range loop
            Free (Argv (Index));
        end loop;
    end Increment_By;
end Redis;
