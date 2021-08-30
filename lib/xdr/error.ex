defmodule XDR.IntError do
  @moduledoc """
  This module contains the definition of `XDR.IntError` exception that may be raised by the `XDR.Int` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.IntError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.IntError{message: msg}
end

defmodule XDR.UIntError do
  @moduledoc """
  This module contains the definition of `XDR.UIntError` exception that may be raised by the `XDR.UInt` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.UIntError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.UIntError{message: msg}
end

defmodule XDR.EnumError do
  @moduledoc """
  This module contains the definition of `XDR.EnumError` exception that may be raised by the `XDR.Enum` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.EnumError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.EnumError{message: msg}
end

defmodule XDR.BoolError do
  @moduledoc """
  This module contains the definition of `XDR.BoolError` exception that may be raised by the `XDR.Bool` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.BoolError` exception with the message of the `error_type` passed.
  """
  def exception(:not_boolean) do
    new("The value which you try to encode is not a boolean")
  end

  def exception(:invalid_value) do
    new("The value which you try to decode must be <<0, 0, 0, 0>> or <<0, 0, 0, 1>>")
  end

  @spec new(msg :: String.t()) :: struct()
  defp new(msg), do: %XDR.BoolError{message: msg}
end

defmodule XDR.HyperIntError do
  @moduledoc """
  This module contains the definition of `XDR.HyperIntError` exception that may be raised by the `XDR.HyperInt` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.HyperIntError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.HyperIntError{message: msg}
end

defmodule XDR.HyperUIntError do
  @moduledoc """
  This module contains the definition of `XDR.HyperUIntError` exception that may be raised by the `XDR.HyperUInt` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.HyperUIntError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.HyperUIntError{message: msg}
end

defmodule XDR.FloatError do
  @moduledoc """
  This module contains the definition of `XDR.FloatError` exception that may be raised by the `XDR.Float` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.FloatError` exception with the message of the `error_type` passed.
  """
  def exception(:not_number) do
    new("The value which you try to encode is not an integer or float value")
  end

  def exception(:not_binary) do
    new("The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>")
  end

  @spec new(msg :: String.t()) :: struct()
  defp new(msg), do: %XDR.FloatError{message: msg}
end

defmodule XDR.DoubleFloatError do
  @moduledoc """
  This module contains the definition of `XDR.DoubleFloatError` exception that may be raised by the `XDR.DoubleFloat` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.DoubleFloatError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.DoubleFloatError{message: msg}
end

defmodule XDR.FixedOpaqueError do
  @moduledoc """
  This module contains the definition of `XDR.FixedOpaqueError` exception that may be raised by the `XDR.FixedOpaque` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.FixedOpaqueError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.FixedOpaqueError{message: msg}
end

defmodule XDR.VariableOpaqueError do
  @moduledoc """
  This module contains the definition of `XDR.VariableOpaqueError` exception that may be raised by the `XDR.VariableOpaque` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.VariableOpaqueError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.VariableOpaqueError{message: msg}
end

defmodule XDR.FixedArrayError do
  @moduledoc """
  This module contains the definition of `XDR.FixedArrayError` exception that may be raised by the `XDR.FixedArray` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.FixedArrayError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.FixedArrayError{message: msg}
end

defmodule XDR.VariableArrayError do
  @moduledoc """
  This module contains the definition of `XDR.VariableArrayError` exception that may be raised by the `XDR.VariableArray` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.VariableArrayError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.VariableArrayError{message: msg}
end

defmodule XDR.StructError do
  @moduledoc """
  This module contains the definition of `XDR.StructError` exception that may be raised by the `XDR.Struct` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.StructError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.StructError{message: msg}
end

defmodule XDR.UnionError do
  @moduledoc """
  This module contains the definition of `XDR.UnionError` exception that may be raised by the `XDR.Union` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.UnionError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.UnionError{message: msg}
end

defmodule XDR.VoidError do
  @moduledoc """
  This module contains the definition of `XDR.VoidError` exception that may be raised by the `XDR.Void` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.VoidError` exception with the message of the `error_type` passed.
  """
  def exception(:not_binary) do
    new("The value which you try to decode must be a binary value, for example: <<0, 0, 0, 5>>")
  end

  def exception(:not_void) do
    new("The value which you try to encode is not void")
  end

  @spec new(msg :: String.t()) :: struct()
  defp new(msg), do: %XDR.VoidError{message: msg}
end

defmodule XDR.OptionalError do
  @moduledoc """
  This module contains the definition of `XDR.OptionalError` exception that may be raised by the `XDR.Optional` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.OptionalError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.OptionalError{message: msg}
end

defmodule XDR.StringError do
  @moduledoc """
  This module contains the definition of `XDR.StringError` exception that may be raised by the `XDR.String` module.
  """

  defexception [:message]

  @impl true
  @doc """
  Create a `XDR.StringError` exception with the message of the `error_type` passed.
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
  defp new(msg), do: %XDR.StringError{message: msg}
end
