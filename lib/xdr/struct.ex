defmodule XDR.Struct do
  @moduledoc """
  this module is in charge of process the struct types based on the RFC4056 XDR Standard
  """

  @behaviour XDR.Declaration

  defstruct struct: nil, components: nil

  @typedoc """
  Every Struct structure has a component keyword which contains the keys and its representation value
  """
  @type t :: %XDR.Struct{struct: binary, components: keyword}

  alias XDR.Error.Struct

  @doc """
  this function provides an easy way to create an XDR.DoubleFloat type

  returns a XDR.DoubleFloat struct with the value received as parameter
  """
  @spec new(components :: keyword, struct :: binary) :: t()
  def new(components, struct \\ <<>>), do: %XDR.Struct{struct: struct, components: components}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode structure types into and XDR format, it receives an XDR.Struct structure
  which contains the structure to encode

  returns an :ok tuple with the resulted XDR
  """
  @spec encode_xdr(t()) :: {:ok, binary}
  def encode_xdr(%XDR.Struct{components: components}) when not is_list(components),
    do: raise(Struct, :not_list)

  def encode_xdr(%XDR.Struct{components: []}), do: raise(Struct, :empty_list)

  def encode_xdr(%XDR.Struct{components: components}) do
    xdr =
      components
      |> Enum.reduce(<<>>, fn {_key, component}, bytes ->
        component_module = component.__struct__
        bytes <> component_module.encode_xdr!(component)
      end)

    {:ok, xdr}
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode structure types into and XDR format, it receives an XDR.Struct structure
  which contains the structure to encode

  returns the resulted XDR
  """
  @spec encode_xdr!(t()) :: binary
  def encode_xdr!(struct), do: encode_xdr(struct) |> elem(1)

  @impl XDR.Declaration
  @doc """
    This function is in charge of decode an XDR into an structure, it receives an XDR.Struct structure
  which contains the binary to encode

  returns an :ok tuple with the resulted struct
  """
  @spec decode_xdr(t()) :: {:ok, {list(), binary()}}
  def decode_xdr(%XDR.Struct{struct: struct}) when not is_binary(struct),
    do: raise(Struct, :not_binary)

  def decode_xdr(%XDR.Struct{components: components}) when not is_list(components),
    do: raise(Struct, :not_list)

  def decode_xdr(%XDR.Struct{struct: struct, components: components}) do
    decode_struct(struct, components)
    |> Keyword.pop!(:rest)
    |> perform_response()
  end

  @impl XDR.Declaration
  @doc """
    This function is in charge of decode an XDR into an structure, it receives an XDR.Struct structure
  which contains the binary to encode

  returns an :ok tuple with the resulted struct
  """
  @spec decode_xdr!(t()) :: {list(), binary()}
  def decode_xdr!(struct), do: decode_xdr(struct) |> elem(1)

  defp decode_struct(struct, []), do: struct

  defp decode_struct(struct, [{key, component} | tail]) do
    {decoded_component, rest} =
      component.new(struct)
      |> component.decode_xdr!()

    keyword1 = Keyword.new([{key, decoded_component}])
    merge_keyword(keyword1, decode_struct(rest, tail))
  end

  @spec merge_keyword(keyword1 :: keyword, keyword) :: keyword
  defp merge_keyword(keyword1, rest) when not is_list(rest),
    do: Keyword.merge(keyword1, rest: rest)

  defp merge_keyword(keyword1, keyword2), do: Keyword.merge(keyword1, keyword2)

  defp perform_response({rest, components}), do: {:ok, {components, rest}}
end
