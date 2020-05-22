defmodule XDR.UInt do
  @behaviour XDR.Declaration
  @moduledoc """
  This module is in charge of process the unsigned integer types based on the RFC4506 XDR Standard
  """

  defstruct datum: nil

  @typedoc """
  Every Unsigned integer structure has a datum which represent the integer value which you try to encode
  """
  @type t :: %XDR.UInt{datum: integer | binary}

  alias XDR.Error.UInt

  @doc """
  this function provides an easy way to create an XDR.UInt type

  returns a XDR.UInt struct with the value received as parameter
  """
  @spec new(datum :: any) :: t
  def new(datum), do: %XDR.UInt{datum: datum}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding an unsigned integers into an XDR if the parameters are wrong
  an error will be raised, it receives a XDR.UInt structure which contains the value to encode

  Returns a tuple with the XDR resulted from encode the unsigned integer value
  """
  @spec encode_xdr(t) ::
          {:ok, binary} | {:error, :not_integer | :exceed_upper_limit | :exceed_lower_limit}
  def encode_xdr(%XDR.UInt{datum: datum}) when not is_integer(datum), do: {:error, :not_integer}

  def encode_xdr(%XDR.UInt{datum: datum}) when datum > 4_294_967_295,
    do: {:error, :exceed_upper_limit}

  def encode_xdr(%XDR.UInt{datum: datum}) when datum < 0, do: {:error, :exceed_lower_limit}
  def encode_xdr(%XDR.UInt{datum: datum}), do: {:ok, <<datum::big-unsigned-integer-size(32)>>}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding an unsigned integers into an XDR if the parameters are wrong
  an error will be raised, it receives a XDR.UInt structure which contains the value to encode

  Returns the XDR resulted from encode the unsigned integer value
  """
  @spec encode_xdr!(t) :: binary
  def encode_xdr!(datum) do
    case encode_xdr(datum) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(UInt, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an unsigned integer value if the parameters are wrong
  an error will be raised, it receives a XDR.UInt structure which contains the binary value to decode

  Returns a tuple with the integer resulted from decode the XDR value
  """
  @spec decode_xdr(binary, any) :: {:ok, {t, binary}} | {:error, :not_binary}
  def decode_xdr(bytes, opts \\ nil)
  def decode_xdr(bytes, _opts) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(bytes, _opts) do
    <<datum::big-unsigned-integer-size(32), rest::binary>> = bytes

    uint = new(datum)
    {:ok, {uint, rest}}
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an unsigned integer value if the parameters are wrong
  an error will be raised, it receives a XDR.UInt structure which contains the binary value to decode

  Returns the integer resulted from decode the XDR value
  """
  @spec decode_xdr!(binary, any) :: {t, binary}
  def decode_xdr!(bytes, opts \\ nil)

  def decode_xdr!(bytes, _opts) do
    case decode_xdr(bytes) do
      {:ok, result} -> result
      {:error, reason} -> raise(UInt, reason)
    end
  end
end
