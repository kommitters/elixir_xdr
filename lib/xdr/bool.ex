defmodule XDR.Bool do
  @moduledoc """
  This module manages the `Boolean` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Enum
  alias XDR.Error.Bool, as: BoolError

  @boolean [false: 0, true: 1]

  defstruct declarations: @boolean, identifier: nil

  @typedoc """
  `XDR.Bool` struct type specification.
  """
  @type t :: %XDR.Bool{declarations: keyword(), identifier: boolean()}

  @doc """
  Create a new `XDR.Bool` structure from the `identifier` passed either `false` or `true`.
  """
  @spec new(identifier :: atom()) :: t
  def new(identifier), do: %XDR.Bool{identifier: identifier}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Bool` structure into a XDR format.
  """
  @spec encode_xdr(boolean :: t) :: {:ok, binary} | {:error, :not_boolean}
  def encode_xdr(%XDR.Bool{identifier: identifier}) when not is_boolean(identifier),
    do: {:error, :not_boolean}

  def encode_xdr(%XDR.Bool{} = boolean), do: Enum.encode_xdr(boolean)

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Bool` structure into a XDR format.
  If the structure received is not `XDR.Bool` or the identifier is not boolean, an exception is raised.
  """
  @spec encode_xdr!(boolean :: t) :: binary()
  def encode_xdr!(boolean) do
    case encode_xdr(boolean) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(BoolError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the Boolean in XDR format to a `XDR.Bool` structure.
  """
  @spec decode_xdr(bytes :: binary, struct :: t | any) ::
          {:ok, {t, binary}} | {:error, :invalid_value}
  def decode_xdr(bytes, struct \\ %XDR.Bool{})
  def decode_xdr(bytes, _struct) when not is_binary(bytes), do: {:error, :invalid_value}

  def decode_xdr(bytes, struct) do
    {enum, rest} = Enum.decode_xdr!(bytes, struct)
    decoded_bool = new(enum.identifier)
    {:ok, {decoded_bool, rest}}
  end

  @impl XDR.Declaration
  @doc """
  Decode the Boolean in XDR format to a `XDR.Bool` structure.
  If the binary is not a valid boolean, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary, struct :: t | any) :: {t, binary}
  def decode_xdr!(bytes, struct \\ %XDR.Bool{})

  def decode_xdr!(bytes, struct) do
    case decode_xdr(bytes, struct) do
      {:ok, result} -> result
      {:error, reason} -> raise(BoolError, reason)
    end
  end
end
