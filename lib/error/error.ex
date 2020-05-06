defmodule XDR.Error do
  @moduledoc """
  Module that is in charge of raise the errors resulted from encode or decode operations
  """

  defmodule Int do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.Int module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.Int module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_integer) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_integer) do
      msg = "The value which you try to encode is not an integer"
      %XDR.Error.Int{message: msg}
    end

    def exception(:not_binary) do
      msg =
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"

      %XDR.Error.Int{message: msg}
    end

    def exception(:exceed_upper_limit) do
      msg =
        "The integer which you try to encode exceed the upper limit of an integer, the value must be less than 2_147_483_647"

      %XDR.Error.Int{message: msg}
    end

    def exception(:exceed_lower_limit) do
      msg =
        "The integer which you try to encode exceed the lower limit of an integer, the value must be more than -2_147_483_648"

      %XDR.Error.Int{message: msg}
    end
  end

  defmodule UInt do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.UInt module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.UInt module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_list) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_integer) do
      msg = "The value which you try to encode is not an integer"
      %XDR.Error.UInt{message: msg}
    end

    def exception(:not_binary) do
      msg =
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"

      %XDR.Error.UInt{message: msg}
    end

    def exception(:exceed_upper_limit) do
      msg =
        "The integer which you try to encode exceed the upper limit of an unsigned integer, the value must be less than 4_294_967_295"

      %XDR.Error.UInt{message: msg}
    end

    def exception(:exceed_lower_limit) do
      msg =
        "The integer which you try to encode exceed the lower limit of an unsigned integer, the value must be more than 0"

      %XDR.Error.UInt{message: msg}
    end
  end

  defmodule Enum do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.Enum module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.Enum module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_list) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_list) do
      msg = "The declaration inside the Enum structure isn't a list"
      %XDR.Error.Enum{message: msg}
    end

    def exception(:not_an_atom) do
      msg = "The name of the key which you try to encode isn't an atom"
      %XDR.Error.Enum{message: msg}
    end

    def exception(:not_valid) do
      msg =
        "The value which you try to decode doesn't belong to the structure which you pass through parameter"

      %XDR.Error.Enum{message: msg}
    end

    def exception(:not_binary) do
      msg =
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"

      %XDR.Error.Enum{message: msg}
    end
  end

  defmodule Bool do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.Bool module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.Bool module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_list) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_boolean) do
      msg = "The value which you try to encode is not a boolean"
      %XDR.Error.Bool{message: msg}
    end

    def exception(:invalid_value) do
      msg = "The value which you try to decode must be <<0, 0, 0, 0>> or <<0, 0, 0, 1>>"
      %XDR.Error.Bool{message: msg}
    end
  end

  defmodule HyperInt do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.HyperInt module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.HyperInt module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_list) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_integer) do
      msg = "The value which you try to encode is not an integer"
      %XDR.Error.HyperInt{message: msg}
    end

    def exception(:not_binary) do
      msg =
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>"

      %XDR.Error.HyperInt{message: msg}
    end

    def exception(:exceed_upper_limit) do
      msg =
        "The integer which you try to encode exceed the upper limit of an Hyper Integer, the value must be less than 9_223_372_036_854_775_807"

      %XDR.Error.HyperInt{message: msg}
    end

    def exception(:exceed_lower_limit) do
      msg =
        "The integer which you try to encode exceed the lower limit of an Hyper Integer, the value must be more than -9_223_372_036_854_775_808"

      %XDR.Error.HyperInt{message: msg}
    end
  end

  defmodule HyperUInt do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.HyperUInt module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.HyperUInt module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_list) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_integer) do
      msg = "The value which you try to encode is not an integer"
      %XDR.Error.HyperUInt{message: msg}
    end

    def exception(:not_binary) do
      msg =
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>"

      %XDR.Error.HyperUInt{message: msg}
    end

    def exception(:exceed_upper_limit) do
      msg =
        "The integer which you try to encode exceed the upper limit of an Hyper Unsigned Integer, the value must be less than 18_446_744_073_709_551_615"

      %XDR.Error.HyperUInt{message: msg}
    end

    def exception(:exceed_lower_limit) do
      msg =
        "The integer which you try to encode exceed the lower limit of an Hyper Unsigned Integer, the value must be more than 0"

      %XDR.Error.HyperUInt{message: msg}
    end
  end

  defmodule Float do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.Float module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.Float module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_integer) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_number) do
      msg = "The value which you try to encode is not an integer or float value"
      %XDR.Error.Float{message: msg}
    end

    def exception(:not_binary) do
      msg =
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"

      %XDR.Error.Float{message: msg}
    end
  end

  defmodule DoubleFloat do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.DoubleFloat module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.DoubleFloat module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_integer) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_number) do
      msg = "The value which you try to encode is not an integer or float value"
      %XDR.Error.DoubleFloat{message: msg}
    end

    def exception(:not_binary) do
      msg =
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>"

      %XDR.Error.DoubleFloat{message: msg}
    end
  end

  defmodule FixedOpaque do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.FixedOpaque module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.FixedOpaque module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_integer) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_number) do
      msg = "The value which you pass through parameters is not an integer"
      %XDR.Error.FixedOpaque{message: msg}
    end

    def exception(:not_binary) do
      msg =
        "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>"

      %XDR.Error.FixedOpaque{message: msg}
    end

    def exception(:invalid_length) do
      msg =
        "The length that is passed through parameters must be equal or less to the byte size of the XDR to complete"

      %XDR.Error.FixedOpaque{message: msg}
    end

    def exception(:exceed_length) do
      msg = "The length is bigger than the byte size of the XDR"

      %XDR.Error.FixedOpaque{message: msg}
    end

    def exception(:not_valid_binary) do
      msg = "The binary size of the binary which you try to decode must be a multiple of 4"

      %XDR.Error.FixedOpaque{message: msg}
    end
  end

  defmodule VariableOpaque do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.VariableOpaque module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.VariableOpaque module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_integer) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_number) do
      msg = "The value which you pass through parameters is not an integer"
      %XDR.Error.VariableOpaque{message: msg}
    end

    def exception(:not_binary) do
      msg =
        "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>"

      %XDR.Error.VariableOpaque{message: msg}
    end

    def exception(:invalid_length) do
      msg =
        "The max length that is passed through parameters must be biger to the byte size of the XDR"

      %XDR.Error.VariableOpaque{message: msg}
    end

    def exception(:exceed_lower_bound) do
      msg = "The minimum value of the length of the variable is 0"

      %XDR.Error.VariableOpaque{message: msg}
    end

    def exception(:exceed_upper_bound) do
      msg = "The maximum value of the length of the variable is 4_294_967_295"

      %XDR.Error.VariableOpaque{message: msg}
    end

    def exception(:length_over_max) do
      msg =
        "The number wich represents the length from decode the opaque as UInt is bigger than the defined max (max by default is 4_294_967_295)"

      %XDR.Error.VariableOpaque{message: msg}
    end

    def exception(:length_over_rest) do
      msg = "The XDR has an invalid length, it must be less than byte-size of the rest"

      %XDR.Error.VariableOpaque{message: msg}
    end
  end

  defmodule String do
    @moduledoc """
    This module is in charge of containing the errors that may be raised by the XDR.String module
    """
    defexception [:message]

    @impl true
    @doc """
    This function is in charge of raise the errors that can be returned by XDR.String module
      ## Parameters:
        the function only have one parameter that is an atom which represents the type of error returned by the module

      ### Example
        def exception(:not_integer) do
          ...
        end

    Raises an exception error when the error is produced
    """
    def exception(:not_bitstring) do
      msg = "the value which you ty to encode must be a bitstring value"
      %XDR.Error.String{message: msg}
    end
  end
end
