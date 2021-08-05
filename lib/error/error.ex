defmodule XDR.Error do
  @moduledoc """
  This module contains the definitions of the errors resulted from XDR encode or decode operations.
  """

  defmodule Int do
    @moduledoc """
    This module contains the definition of `XDR.Error.Int` exception that may be raised by the `XDR.Int` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.Int` exception with the message of the `error_type` passed.
    """
    def exception(:not_integer) do
      new("The value which you try to encode is not an integer")
    end

    def exception(:not_binary) do
      new("The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>")
    end

    def exception(:exceed_upper_limit) do
      new(
        "The integer which you try to encode exceed the upper limit of an integer, the value must be less than 2_147_483_647"
      )
    end

    def exception(:exceed_lower_limit) do
      new(
        "The integer which you try to encode exceed the lower limit of an integer, the value must be more than -2_147_483_648"
      )
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.Int{message: msg}
  end

  defmodule UInt do
    @moduledoc """
    This module contains the definition of `XDR.Error.UInt` exception that may be raised by the `XDR.UInt` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.UInt` exception with the message of the `error_type` passed.
    """
    def exception(:not_integer) do
      new("The value which you try to encode is not an integer")
    end

    def exception(:not_binary) do
      new("The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>")
    end

    def exception(:exceed_upper_limit) do
      new(
        "The integer which you try to encode exceed the upper limit of an unsigned integer, the value must be less than 4_294_967_295"
      )
    end

    def exception(:exceed_lower_limit) do
      new(
        "The integer which you try to encode exceed the lower limit of an unsigned integer, the value must be more than 0"
      )
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.UInt{message: msg}
  end

  defmodule Enum do
    @moduledoc """
    This module contains the definition of `XDR.Error.Enum` exception that may be raised by the `XDR.Enum` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.Enum` exception with the message of the `error_type` passed.
    """
    def exception(:not_list) do
      new("The declaration inside the Enum structure isn't a list")
    end

    def exception(:not_an_atom) do
      new("The name of the key which you try to encode isn't an atom")
    end

    def exception(:not_binary) do
      new("The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>")
    end

    def exception(:invalid_key) do
      new("The key which you try to encode doesn't belong to the current declarations")
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.Enum{message: msg}
  end

  defmodule Bool do
    @moduledoc """
    This module contains the definition of `XDR.Error.Bool` exception that may be raised by the `XDR.Bool` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.Bool` exception with the message of the `error_type` passed.
    """
    def exception(:not_boolean) do
      new("The value which you try to encode is not a boolean")
    end

    def exception(:invalid_value) do
      new("The value which you try to decode must be <<0, 0, 0, 0>> or <<0, 0, 0, 1>>")
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.Bool{message: msg}
  end

  defmodule HyperInt do
    @moduledoc """
    This module contains the definition of `XDR.Error.HyperInt` exception that may be raised by the `XDR.HyperInt` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.HyperInt` exception with the message of the `error_type` passed.
    """
    def exception(:not_integer) do
      new("The value which you try to encode is not an integer")
    end

    def exception(:not_binary) do
      new(
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>"
      )
    end

    def exception(:exceed_upper_limit) do
      new(
        "The integer which you try to encode exceed the upper limit of an Hyper Integer, the value must be less than 9_223_372_036_854_775_807"
      )
    end

    def exception(:exceed_lower_limit) do
      new(
        "The integer which you try to encode exceed the lower limit of an Hyper Integer, the value must be more than -9_223_372_036_854_775_808"
      )
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.HyperInt{message: msg}
  end

  defmodule HyperUInt do
    @moduledoc """
    This module contains the definition of `XDR.Error.HyperUInt` exception that may be raised by the `XDR.HyperUInt` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.HyperUInt` exception with the message of the `error_type` passed.
    """
    def exception(:not_integer) do
      new("The value which you try to encode is not an integer")
    end

    def exception(:not_binary) do
      new(
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>"
      )
    end

    def exception(:exceed_upper_limit) do
      new(
        "The integer which you try to encode exceed the upper limit of an Hyper Unsigned Integer, the value must be less than 18_446_744_073_709_551_615"
      )
    end

    def exception(:exceed_lower_limit) do
      new(
        "The integer which you try to encode exceed the lower limit of an Hyper Unsigned Integer, the value must be more than 0"
      )
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.HyperUInt{message: msg}
  end

  defmodule Float do
    @moduledoc """
    This module contains the definition of `XDR.Error.Float` exception that may be raised by the `XDR.Float` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.Float` exception with the message of the `error_type` passed.
    """
    def exception(:not_number) do
      new("The value which you try to encode is not an integer or float value")
    end

    def exception(:not_binary) do
      new("The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>")
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.Float{message: msg}
  end

  defmodule DoubleFloat do
    @moduledoc """
    This module contains the definition of `XDR.Error.DoubleFloat` exception that may be raised by the `XDR.DoubleFloat` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.DoubleFloat` exception with the message of the `error_type` passed.
    """
    def exception(:not_number) do
      new("The value which you try to encode is not an integer or float value")
    end

    def exception(:not_binary) do
      new(
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>"
      )
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.DoubleFloat{message: msg}
  end

  defmodule FixedOpaque do
    @moduledoc """
    This module contains the definition of `XDR.Error.FixedOpaque` exception that may be raised by the `XDR.FixedOpaque` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.FixedOpaque` exception with the message of the `error_type` passed.
    """
    def exception(:not_number) do
      new("The value which you pass through parameters is not an integer")
    end

    def exception(:not_binary) do
      new(
        "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>"
      )
    end

    def exception(:invalid_length) do
      new(
        "The length that is passed through parameters must be equal or less to the byte size of the XDR to complete"
      )
    end

    def exception(:exceed_length) do
      new("The length is bigger than the byte size of the XDR")
    end

    def exception(:not_valid_binary) do
      new("The binary size of the binary which you try to decode must be a multiple of 4")
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.FixedOpaque{message: msg}
  end

  defmodule VariableOpaque do
    @moduledoc """
    This module contains the definition of `XDR.Error.VariableOpaque` exception that may be raised by the `XDR.VariableOpaque` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.VariableOpaque` exception with the message of the `error_type` passed.
    """
    def exception(:not_number) do
      new("The value which you pass through parameters is not an integer")
    end

    def exception(:not_binary) do
      new(
        "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>"
      )
    end

    def exception(:invalid_length) do
      new(
        "The max length that is passed through parameters must be biger to the byte size of the XDR"
      )
    end

    def exception(:exceed_lower_bound) do
      new("The minimum value of the length of the variable is 0")
    end

    def exception(:exceed_upper_bound) do
      new("The maximum value of the length of the variable is 4_294_967_295")
    end

    def exception(:length_over_max) do
      new(
        "The number which represents the length from decode the opaque as UInt is bigger than the defined max (max by default is 4_294_967_295)"
      )
    end

    def exception(:length_over_rest) do
      new("The XDR has an invalid length, it must be less than byte-size of the rest")
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.VariableOpaque{message: msg}
  end

  defmodule String do
    @moduledoc """
    This module contains the definition of `XDR.Error.String` exception that may be raised by the `XDR.String` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.String` exception with the message of the `error_type` passed.
    """
    def exception(:not_bitstring) do
      new("The value you are trying to encode must be a bitstring value")
    end

    def exception(:invalid_length) do
      new("The length of the string exceeds the max length allowed")
    end

    def exception(:not_binary) do
      new("The value you are trying to decode must be a binary value")
    end

    @spec new(msg :: binary()) :: struct()
    defp new(msg), do: %XDR.Error.String{message: msg}
  end

  defmodule FixedArray do
    @moduledoc """
    This module contains the definition of `XDR.Error.FixedArray` exception that may be raised by the `XDR.FixedArray` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.FixedArray` exception with the message of the `error_type` passed.
    """
    def exception(:invalid_length) do
      new("the length of the array and the length must be the same")
    end

    def exception(:not_list) do
      new("the value which you try to encode must be a list")
    end

    def exception(:not_number) do
      new("the length received by parameter must be an integer")
    end

    def exception(:not_binary) do
      new("the value which you try to decode must be a binary value")
    end

    def exception(:not_valid_binary) do
      new("the value which you try to decode must have a multiple of 4 byte-size")
    end

    def exception(:invalid_type) do
      new("the type must be a module")
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.FixedArray{message: msg}
  end

  defmodule VariableArray do
    @moduledoc """
    This module contains the definition of `XDR.Error.VariableArray` exception that may be raised by the `XDR.VariableArray` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.VariableArray` exception with the message of the `error_type` passed.
    """
    def exception(:not_list) do
      new("the value which you try to encode must be a list")
    end

    def exception(:not_number) do
      new("the max length must be an integer value")
    end

    def exception(:not_binary) do
      new(
        "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>"
      )
    end

    def exception(:exceed_lower_bound) do
      new("The minimum value of the length of the variable is 1")
    end

    def exception(:exceed_upper_bound) do
      new("The maximum value of the length of the variable is 4_294_967_295")
    end

    def exception(:length_over_max) do
      new(
        "The number which represents the length from decode the opaque as UInt is bigger than the defined max"
      )
    end

    def exception(:invalid_length) do
      new("The length of the binary exceeds the max_length of the type")
    end

    def exception(:invalid_binary) do
      new(
        "The data which you try to decode has an invalid number of bytes, it must be equal to or greater than the size of the array multiplied by 4"
      )
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.VariableArray{message: msg}
  end

  defmodule Struct do
    @moduledoc """
    This module contains the definition of `XDR.Error.Struct` exception that may be raised by the `XDR.Struct` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.Struct` exception with the message of the `error_type` passed.
    """
    def exception(:not_list) do
      new("The :components received by parameter must be a keyword list")
    end

    def exception(:empty_list) do
      new("The :components must not be empty, it must be a keyword list")
    end

    def exception(:not_binary) do
      new("The :struct received by parameter must be a binary value, for example: <<0, 0, 0, 5>>")
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.Struct{message: msg}
  end

  defmodule Union do
    @moduledoc """
    This module contains the definition of `XDR.Error.Union` exception that may be raised by the `XDR.Union` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.Union` exception with the message of the `error_type` passed.
    """
    def exception(:not_list) do
      new(
        "The :declarations received by parameter must be a keyword list which belongs to an XDR.Enum"
      )
    end

    def exception(:not_binary) do
      new(
        "The :identifier received by parameter must be a binary value, for example: <<0, 0, 0, 5>>"
      )
    end

    def exception(:not_number) do
      new("The value which you try to decode is not an integer value")
    end

    def exception(:not_atom) do
      new("The :identifier which you try to decode from the Enum Union is not an atom")
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.Union{message: msg}
  end

  defmodule Void do
    @moduledoc """
    This module contains the definition of `XDR.Error.Void` exception that may be raised by the `XDR.Void` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.Void` exception with the message of the `error_type` passed.
    """
    def exception(:not_binary) do
      new("The value which you try to decode must be a binary value, for example: <<0, 0, 0, 5>>")
    end

    def exception(:not_void) do
      new("The value which you try to encode is not void")
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.Void{message: msg}
  end

  defmodule Optional do
    @moduledoc """
    This module contains the definition of `XDR.Error.Optional` exception that may be raised by the `XDR.Optional` module.
    """

    defexception [:message]

    @impl true
    @doc """
    Create a `XDR.Error.Optional` exception with the message of the `error_type` passed.
    """
    def exception(:not_valid) do
      new("The value which you try to encode must be Int, UInt or Enum")
    end

    def exception(:not_binary) do
      new("The value which you try to decode must be a binary value")
    end

    def exception(:not_module) do
      new("The type of the optional value must be the module which it belongs")
    end

    @spec new(msg :: String.t()) :: struct()
    defp new(msg), do: %XDR.Error.Optional{message: msg}
  end
end
