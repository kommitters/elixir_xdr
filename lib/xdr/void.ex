defmodule XDR.Void do
  @moduledoc """
  This module manages the `Void` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.Void, as: VoidError

  defstruct [:void]

  @typedoc """
  `XDR.Void` struct type specification.
  """
  @type t :: %XDR.Void{void: nil}

  @doc """
  Create a new `XDR.Void` structure from the `value` passed.
  """
  @spec new(value :: nil) :: t
  def new(value \\ nil) when is_nil(value), do: %XDR.Void{}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Void` structure into a XDR format.
  """
  @spec encode_xdr(void :: t) :: {:ok, binary} | {:error, :not_void}
  def encode_xdr(%XDR.Void{void: nil}), do: {:ok, <<>>}
  def encode_xdr(_), do: {:error, :not_void}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Void` structure into a XDR format.
  If the structure received is not `XDR.Void`, an exception is raised.
  """
  @spec encode_xdr!(void :: t) :: binary()
  def encode_xdr!(void) do
    case encode_xdr(void) do
      {:ok, result} -> result
      {:error, reason} -> raise(VoidError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the XDR format to a void format.
  """
  @spec decode_xdr(bytes :: binary(), void :: t) :: {:ok, {nil, binary}} | {:error, :not_binary}
  def decode_xdr(bytes, _void \\ nil)
  def decode_xdr(<<rest::binary>>, _), do: {:ok, {nil, rest}}
  def decode_xdr(_, _), do: {:error, :not_binary}

  @impl XDR.Declaration
  @doc """
  Decode the XDR format to a void format.
  If the binary is not a valid void, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary(), void :: t) :: {nil, binary}
  def decode_xdr!(bytes, _void \\ nil) do
    case decode_xdr(bytes) do
      {:ok, result} -> result
      {:error, reason} -> raise(VoidError, reason)
    end
  end
end
