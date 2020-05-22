defmodule XDR.Enum do
  @behaviour XDR.Declaration
  @moduledoc """
  This module is in charge to process the Enum type based on the RFC4506 XDR Standard
  """

  alias XDR.Error.Enum, as: EnumErr

  defstruct declarations: nil, identifier: nil

  @typedoc """
  Every enum structure has a declaration list which contains the keys and its representation value
  """
  @type t :: %XDR.Enum{declarations: keyword, identifier: atom}

  def new(declarations, identifier),
    do: %XDR.Enum{declarations: declarations, identifier: identifier}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode a value inside of the enum structure based on the identifier received by parameter, it receives
  a XDR.Enum type which contains the Enum and the identifier which you need to encode

  Returns a tuple with the the XDR resulted from encode the value wich represents a key in the enum structure
  """
  @spec encode_xdr(map) :: {:ok, binary} | {:error, :not_list | :not_an_atom | :invalid_key}
  def encode_xdr(%{declarations: declarations}) when not is_list(declarations),
    do: {:error, :not_list}

  def encode_xdr(%{identifier: identifier}) when not is_atom(identifier),
    do: {:error, :not_an_atom}

  def encode_xdr(%{declarations: declarations, identifier: identifier}) do
    Keyword.has_key?(declarations, identifier)
    |> encode_valid_data(declarations, identifier)
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode a value inside of the enum structure based on the identifier received by parameter, it receives
  a XDR.Enum type which contains the Enum and the identifier which you need to encode

  Returns the XDR resulted from encode the value wich represents a key in the enum structure
  """
  @spec encode_xdr!(enum :: map) :: binary
  def encode_xdr!(enum) do
    case encode_xdr(enum) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(EnumErr, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR which represents a value inside an enum structure,it receives an XDR.Enum structure that
  contains the identifier and the enum which it belongs

  Returns a tuple with the key of the decoded enum and the remaining bytes if there are.
  """
  @spec decode_xdr(binary, map) ::
          {:ok, {t(), binary}} | {:error, :not_binary | :not_list | :invalid_key}
  def decode_xdr(bytes, %{}) when not is_binary(bytes),
    do: {:error, :not_binary}

  def decode_xdr(_bytes, %{declarations: declarations}) when not is_list(declarations),
    do: {:error, :not_list}

  def decode_xdr(bytes, %{declarations: declarations}) do
    {value, rest} = XDR.Int.decode_xdr!(bytes)

    identifier = Enum.find(declarations, &Kernel.===(elem(&1, 1), value.datum)) |> get_response()

    decoded_enum = new(declarations, identifier)

    Keyword.has_key?(declarations, identifier)
    |> add_valid_key(decoded_enum, rest)
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR which represents a value inside an enum structure,it receives an XDR.Enum structure that
  contains the identifier and the enum which it belongs

  Returns the key of the decoded enum and the remaining bytes if there are.
  """
  @spec decode_xdr!(binary, map) :: {t(), binary}
  def decode_xdr!(bytes, struct) do
    case decode_xdr(bytes, struct) do
      {:ok, result} -> result
      {:error, reason} -> raise(EnumErr, reason)
    end
  end

  @spec get_response({atom(), any}) :: atom()
  defp get_response({identifier, _}), do: identifier

  @spec get_response(nil) :: nil
  defp get_response(nil), do: nil

  @spec add_valid_key(boolean(), map(), rest :: binary()) ::
          {:ok, {t, binary}} | {:error, :invalid_key}
  defp add_valid_key(true, decoded_enum, rest), do: {:ok, {decoded_enum, rest}}

  defp add_valid_key(false, _enum, _rest), do: {:error, :invalid_key}

  @spec encode_valid_data(boolean(), declarations :: keyword(), identifier :: atom()) ::
          {:ok, binary()}
  defp encode_valid_data(true, declarations, identifier) do
    binary =
      declarations[identifier]
      |> XDR.Int.new()
      |> XDR.Int.encode_xdr!()

    {:ok, binary}
  end

  defp encode_valid_data(false, _declarations, _identifier), do: {:error, :invalid_key}
end
