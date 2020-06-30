defmodule XDR.Int do
  @moduledoc """
  This module manages the `Integer` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.Int, as: IntError

  defstruct [:datum]

  @typedoc """
  `XDR.Int` structure type specification.
  """
  @type t :: %XDR.Int{datum: integer}

  @doc """
  Create a new `XDR.Int` structure with the `opaque` and `length` passed.
  """
  @spec new(datum :: integer) :: t
  def new(datum), do: %XDR.Int{datum: datum}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Int` structure into a XDR format.
  """
  @spec encode_xdr(int :: t) ::
          {:ok, binary} | {:error, :not_integer | :exceed_upper_limit | :exceed_lower_limit}
  def encode_xdr(%XDR.Int{datum: datum}) when not is_integer(datum), do: {:error, :not_integer}

  def encode_xdr(%XDR.Int{datum: datum}) when datum > 2_147_483_647,
    do: {:error, :exceed_upper_limit}

  def encode_xdr(%XDR.Int{datum: datum}) when datum < -2_147_483_648,
    do: {:error, :exceed_lower_limit}

  def encode_xdr(%XDR.Int{datum: datum}), do: {:ok, <<datum::big-signed-integer-size(32)>>}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Int` structure into a XDR format.
  If the `int` is not valid, an exception is raised.
  """
  @spec encode_xdr!(int :: t) :: binary()
  def encode_xdr!(int) do
    case encode_xdr(int) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(IntError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the Integer in XDR format to a `XDR.Int` structure.
  """
  @spec decode_xdr(bytes :: binary(), int :: t) :: {:ok, {t, binary}} | {:error, :not_binary}
  def decode_xdr(bytes, int \\ nil)
  def decode_xdr(bytes, _int) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(<<datum::big-signed-integer-size(32), rest::binary>>, _int),
    do: {:ok, {new(datum), rest}}

  @impl XDR.Declaration
  @doc """
  Decode the Integer in XDR format to a `XDR.Int` structure.
  If the binaries are not valid, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary(), int :: t) :: {t, binary()}
  def decode_xdr!(bytes, int \\ nil)

  def decode_xdr!(bytes, _int) do
    case decode_xdr(bytes) do
      {:ok, result} -> result
      {:error, reason} -> raise(IntError, reason)
    end
  end
end
