defmodule XDR.Int do
  @behaviour XDR.Declaration
  @moduledoc """
  This module is in charge of process the integer types based on the RFC4506 XDR Standard
  """

  defstruct datum: nil

  @typedoc """
  Every integer structure has a datum which represent the integer value which you try to encode
  """
  @type t :: %XDR.Int{datum: integer}

  alias XDR.Error.Int

  @doc """
  this function provides an easy way to create an XDR.Int type

  returns a XDR.Int struct with the value received as parameter
  """
  @spec new(datum :: integer) :: t
  def new(datum), do: %XDR.Int{datum: datum}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding a integer value into an XDR if the parameters are wrong an error will be raised
  it receives an XDR.Int structure

  Returns a tuple with the XDR resulted from encoding the integer value
  """
  @spec encode_xdr(t) ::
          {:ok, binary} | {:error, :not_integer | :exceed_upper_limit | :exceed_lower_limit}
  def encode_xdr(%XDR.Int{datum: datum}) when not is_integer(datum), do: {:error, :not_integer}

  def encode_xdr(%XDR.Int{datum: datum}) when datum > 2_147_483_647,
    do: {:error, :exceed_upper_limit}

  def encode_xdr(%XDR.Int{datum: datum}) when datum < -2_147_483_648,
    do: {:error, :exceed_lower_limit}

  def encode_xdr(%XDR.Int{datum: datum}), do: {:ok, <<datum::big-signed-integer-size(32)>>}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding a integer value into an XDR if the parameters are wrong an error will be raised
  it receives an XDR.Int structure

  Returns the XDR resulted from encoding the integer value
  """
  @spec encode_xdr!(datum :: t) :: binary
  def encode_xdr!(datum) do
    case encode_xdr(datum) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(Int, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an integer value if the parameters are wrong
  an error will be raised, it receives an XDR.Int structure which contains the binary value to decode

  Returns a tuple with the integer resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr(binary, any) :: {:ok, {t, binary}} | {:error, :not_binary}
  def decode_xdr(bytes, opts \\ nil)
  def decode_xdr(bytes, _opts) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(bytes, _opts) do
    <<datum::big-signed-integer-size(32), rest::binary>> = bytes

    int = new(datum)

    {:ok, {int, rest}}
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an integer value if the parameters are wrong
  an error will be raised, it receives an XDR.Int structure which contains the binary value to decode

  Returns the integer resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr!(binary, any) :: {t, binary}
  def decode_xdr!(bytes, opts \\ nil)

  def decode_xdr!(bytes, _opts) do
    case decode_xdr(bytes) do
      {:ok, result} -> result
      {:error, reason} -> raise(Int, reason)
    end
  end
end
