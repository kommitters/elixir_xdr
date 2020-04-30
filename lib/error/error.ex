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
        "The integer which you try to encode exceed the upper limit of an integer, the value must be less than 2147483647"

      %XDR.Error.Int{message: msg}
    end

    def exception(:exceed_lower_limit) do
      msg =
        "The integer which you try to encode exceed the lower limit of an integer, the value must be more than -2147483648"

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
      msg = "The value which you try to encode is not an unsigned integer"
      %XDR.Error.UInt{message: msg}
    end

    def exception(:not_binary) do
      msg =
        "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"

      %XDR.Error.UInt{message: msg}
    end

    def exception(:exceed_upper_limit) do
      msg =
        "The integer which you try to encode exceed the upper limit of an unsigned integer, the value must be less than 4294967295"

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
      %XDR.Error.Enum{message: msg}
    end
  end
end
