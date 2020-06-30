defmodule XDR.Enum do
  @moduledoc """
  This module manages the `Enumeration` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.Enum, as: EnumError

  defstruct [:declarations, :identifier]

  @typedoc """
  `XDR.Enum` structure type specification.
  """
  @type t :: %XDR.Enum{declarations: keyword(), identifier: atom()}

  @doc """
  Create a new `XDR.Enum` structure with the `declarations` and `identifier` passed.
  """
  def new(declarations, identifier),
    do: %XDR.Enum{declarations: declarations, identifier: identifier}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Enum` structure into a XDR format.
  """
  @spec encode_xdr(map) :: {:ok, binary} | {:error, :not_list | :not_an_atom | :invalid_key}
  def encode_xdr(%{declarations: declarations}) when not is_list(declarations),
    do: {:error, :not_list}

  def encode_xdr(%{identifier: identifier}) when not is_atom(identifier),
    do: {:error, :not_an_atom}

  def encode_xdr(%{declarations: declarations, identifier: identifier}) do
    case Keyword.has_key?(declarations, identifier) do
      true -> encode_valid_data(declarations, identifier)
      false -> {:error, :invalid_key}
    end
  end

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Enum` structure into a XDR format.
  If the `declarations` or `identifier` of the `enum` is not valid, an exception is raised.
  """
  @spec encode_xdr!(enum :: t) :: binary
  def encode_xdr!(enum) do
    case encode_xdr(enum) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(EnumError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the Enumeration in XDR format to a `XDR.Enum` structure.
  """
  @spec decode_xdr(bytes :: binary(), enum :: t) ::
          {:ok, {t, binary}} | {:error, :not_binary | :not_list | :invalid_key}
  def decode_xdr(bytes, %{}) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(_bytes, %{declarations: declarations}) when not is_list(declarations),
    do: {:error, :not_list}

  def decode_xdr(bytes, %{declarations: declarations}) do
    {int_xdr, rest} = XDR.Int.decode_xdr!(bytes)

    declarations
    |> Enum.find(fn {_key, value} -> value === int_xdr.datum end)
    |> decoded_enum(declarations, rest)
  end

  @spec decoded_enum(
          identifier :: {atom(), any()} | nil,
          declarations :: keyword(),
          rest :: binary()
        ) :: {:ok, {t, binary}} | {:error, :invalid_key}
  defp decoded_enum(nil, _declarations, _rest), do: {:error, :invalid_key}

  defp decoded_enum({identifier, _value}, declarations, rest) do
    decoded_enum = new(declarations, identifier)
    {:ok, {decoded_enum, rest}}
  end

  @impl XDR.Declaration
  @doc """
  Decode the Enumeration in XDR format to a `XDR.Enum` structure.
  If the binaries are not valid, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary(), enum :: t) :: {t, binary()}
  def decode_xdr!(bytes, enum) do
    case decode_xdr(bytes, enum) do
      {:ok, result} -> result
      {:error, reason} -> raise(EnumError, reason)
    end
  end

  @spec encode_valid_data(declarations :: keyword(), identifier :: atom()) :: {:ok, binary()}
  defp encode_valid_data(declarations, identifier) do
    binary = declarations[identifier] |> XDR.Int.new() |> XDR.Int.encode_xdr!()
    {:ok, binary}
  end
end
