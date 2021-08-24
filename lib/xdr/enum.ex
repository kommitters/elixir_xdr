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
  @spec new(declarations :: list(), identifier :: atom()) :: t()
  def new(declarations, identifier),
    do: %XDR.Enum{declarations: declarations, identifier: identifier}

  @doc """
  Encode a `XDR.Enum` structure into a XDR format.
  """
  @impl true
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

  @doc """
  Encode a `XDR.Enum` structure into a XDR format.
  If the `declarations` or `identifier` of the `enum` is not valid, an exception is raised.
  """
  @impl true
  def encode_xdr!(enum) do
    case encode_xdr(enum) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(EnumError, reason)
    end
  end

  @doc """
  Decode the Enumeration in XDR format to a `XDR.Enum` structure.
  """
  @impl true
  def decode_xdr(bytes, %{}) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(_bytes, %{declarations: declarations}) when not is_list(declarations),
    do: {:error, :not_list}

  def decode_xdr(bytes, %{declarations: declarations}) do
    {int_xdr, rest} = XDR.Int.decode_xdr!(bytes)

    declarations
    |> Enum.find(fn {_key, value} -> value === int_xdr.datum end)
    |> decoded_enum(declarations, rest)
  end

  @doc """
  Decode the Enumeration in XDR format to a `XDR.Enum` structure.
  If the binaries are not valid, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, enum) do
    case decode_xdr(bytes, enum) do
      {:ok, result} -> result
      {:error, reason} -> raise(EnumError, reason)
    end
  end

  @spec decoded_enum(
          identifier :: {atom(), any()} | nil,
          declarations :: keyword(),
          rest :: binary()
        ) :: {:ok, {t(), binary()}} | {:error, :invalid_key}
  defp decoded_enum(nil, _declarations, _rest), do: {:error, :invalid_key}

  defp decoded_enum({identifier, _value}, declarations, rest) do
    decoded_enum = new(declarations, identifier)
    {:ok, {decoded_enum, rest}}
  end

  @spec encode_valid_data(declarations :: keyword(), identifier :: atom()) :: {:ok, binary()}
  defp encode_valid_data(declarations, identifier) do
    binary = declarations[identifier] |> XDR.Int.new() |> XDR.Int.encode_xdr!()
    {:ok, binary}
  end
end
