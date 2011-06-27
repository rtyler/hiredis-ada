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

    -------------------------------------------------------
    --
    -------------------------------------------------------
    procedure Set (C : in Redis.Connection; Key : in String; Value : in String) is
        Unused : System.Address;
        Argv : Hiredis.Command_Array (0 .. 2);
    begin
        Argv (0) := SET_CMD;
        Argv (1) := New_String (Key);
        Argv (2) := New_String (Value);

        Execute (C, Argv, Unused);
    end Set;

    -------------------------------------------------------
    --
    -------------------------------------------------------

    procedure Incr (C : Connection; Key : in String) is
    begin
        Increment (C, Key);
    end Incr;

    procedure Increment (C : Connection; Key : in String) is
        Unused : System.Address;
        Argv : Hiredis.Command_Array (0 .. 1);
    begin
        Argv (0) := INCR_CMD;
        Argv (1) := New_String (Key);

        Execute (C, Argv, Unused);
    end Increment;

    -------------------------------------------------------
    --
    -------------------------------------------------------

    procedure IncrBy (C : Connection; Key : in String; Value : in Integer) is
    begin
        Increment_By (C, Key, Value);
    end IncrBy;

    procedure Increment_By (C : Connection; Key : in String; Value : in Integer) is
        Unused : System.Address;
        Argv : Hiredis.Command_Array (0 .. 2);
    begin
        Argv (0) := INCRBY_CMD;
        Argv (1) := New_String (Key);
        Argv (2) := New_String (Integer'Image (Value));

        Execute (C, Argv, Unused);
    end Increment_By;

    -------------------------------------------------------
    --
    -------------------------------------------------------

    procedure Decr (C : Connection; Key : in String) is
    begin
        Decrement (C, Key);
    end Decr;

    procedure Decrement (C : Connection; Key : in String) is
        Unused : System.Address;
        Argv : Hiredis.Command_Array (0 .. 1);
    begin
        Argv (0) := DECR_CMD;
        Argv (1) := New_String (Key);

        Execute (C, Argv, Unused);
    end Decrement;

    procedure DecrBy (C : Connection; Key : in String; Value : in Integer) is
    begin
        Decrement_By (C, Key, Value);
    end DecrBy;

    procedure Decrement_By (C : Connection; Key : in String; Value : in Integer) is
        Unused : System.Address;
        Argv : Hiredis.Command_Array (0 .. 2);
    begin
        Argv (0) := DECRBY_CMD;
        Argv (1) := New_String (Key);
        Argv (2) := New_String (Integer'Image (Value));

        Execute (C, Argv, Unused);
    end Decrement_By;


    -------------------------------------------------------
    --  Private procedures and functions
    -------------------------------------------------------

    procedure Execute (C : in Connection;
                       Commands : in out Hiredis.Command_Array;
                       Reply : out System.Address) is
    begin
        Reply := Hiredis.redisCommandArgv (C.Context, Commands'Length, Commands, null);


        for Index in 1 .. (Commands'Length - 1) loop
            Free (Commands (Index));
        end loop;
    end Execute;
end Redis;
