defmodule XDR.UnionTest do
  use ExUnit.Case

  alias XDR.Union
  alias XDR.Error.Union, as: UnionErr

  describe "Encoding discriminated union" do
    test "when receives an invalid identifier" do
      # Enum structure with invalid identifier
      enum = %{
        declarations: [
          SCP_ST_PREPARE: 0,
          SCP_ST_CONFIRM: 1,
          SCP_ST_EXTERNALIZE: 2,
          SCP_ST_NOMINATE: 3
        ],
        identifier: "SCP_ST_EXTERNALIZE"
      }

      # Valid arms for the union encode
      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      try do
        Union.encode_xdr(%{discriminant: enum, arms: arms})
      rescue
        error ->
          assert error == %UnionErr{
                   message:
                     "The :identifier which you try to decode from the Enum Union is not an atom"
                 }
      end
    end

    test "Enum example" do
      {status, result} =
        SCPStatementType.new(:SCP_ST_PREPARE)
        # Union type definition, it contains the same arms that you can see on the line 21
        |> UnionEnum.new()
        # It also can use the XDR.UnionEnum.decode_xdr()/1 function
        |> Union.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 0, 60>>
    end

    test "Uint example" do
      {status, result} =
        XDR.UInt.new(3)
        # Union type definition, it contains the same arms that you can see on the line 21
        |> UnionNumber.new()
        # It also can use the XDR.UnionNumber.decode_xdr()/1 function
        |> Union.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 3, 64, 93, 112, 164>>
    end
  end

  describe "Decoding Discriminated Union" do
    test "when receives an invalid identifier" do
      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      try do
        Union.decode_xdr(%{discriminant: %{identifier: [0, 0, 0, 0, 0, 0, 0, 0]}, arms: arms})
      rescue
        error ->
          assert error == %UnionErr{
                   message:
                     "The :identifier received by parameter must be a binary value, for example: <<0, 0, 0, 5>>"
                 }
      end
    end

    test "when receives an invalid declarations" do
      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      try do
        Union.decode_xdr(%{discriminant: %{declarations: <<0, 0, 0, 0, 0, 0, 0, 0>>}, arms: arms})
      rescue
        error ->
          assert error == %UnionErr{
                   message:
                     "The :declarations received by parameter must be a keyword list which belongs to an XDR.Enum"
                 }
      end
    end

    test "Enum example" do
      {status, result} =
        SCPStatementType.new(<<0, 0, 0, 0, 0, 0, 0, 60>>)
        # Union type definition, it contains the same arms that you can see on the line 21
        |> UnionEnum.new()
        # It also can use the XDR.UnionEnum.decode_xdr()/1 function
        |> Union.decode_xdr()

      assert status == :ok
      assert result == {{:SCP_ST_PREPARE, 60}, ""}
    end

    test "Uint example" do
      # Union type definition, it contains the same arms that you can see on the line 21
      {status, result} =
        UnionNumber.new(<<0, 0, 0, 3, 64, 93, 112, 164>>)
        # It also can use the XDR.UnionNumber.decode_xdr()/1 function
        |> Union.decode_xdr()

      assert status == :ok
      assert result == {{3, 3.4600000381469727}, ""}
    end
  end
end

defmodule UnionEnum do
  @behaviour XDR.Declaration

  defstruct discriminant: XDR.Enum, arms: nil, struct: nil

  @arms [
    SCP_ST_PREPARE: XDR.Int.new(60),
    SCP_ST_CONFIRM: XDR.String.new("Confirm"),
    SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
    SCP_ST_NOMINATE: XDR.Float.new(3.46)
  ]

  def new(discriminant),
    do: %UnionEnum{
      discriminant: discriminant,
      arms: @arms,
      struct: UnionEnum.__struct__()
    }

  @impl XDR.Declaration
  def encode_xdr(%UnionEnum{} = union), do: XDR.Union.encode_xdr(union)

  @impl XDR.Declaration
  def encode_xdr!(%UnionEnum{} = union), do: encode_xdr(union) |> elem(1)

  @impl XDR.Declaration
  def decode_xdr(%UnionEnum{} = union), do: XDR.Union.decode_xdr(union)

  @impl XDR.Declaration
  def decode_xdr!(%UnionEnum{} = union), do: XDR.Union.decode_xdr!(union)
end

defmodule UnionNumber do
  @behaviour XDR.Declaration

  defstruct discriminant: XDR.UInt, arms: nil, struct: nil

  @arms %{
    0 => XDR.Int.new(60),
    1 => XDR.String.new("Confirm"),
    2 => XDR.Bool.new(false),
    3 => XDR.Float.new(3.46)
  }

  def new(discriminant),
    do: %UnionNumber{discriminant: discriminant, arms: @arms, struct: UnionNumber.__struct__()}

  @impl XDR.Declaration
  def encode_xdr(%UnionNumber{} = union), do: XDR.Union.encode_xdr(union)
  @impl XDR.Declaration
  def encode_xdr!(%UnionNumber{} = union), do: XDR.Union.encode_xdr!(union)
  @impl XDR.Declaration
  def decode_xdr(%UnionNumber{} = union), do: XDR.Union.decode_xdr(union)
  @impl XDR.Declaration
  def decode_xdr!(%UnionNumber{} = union), do: XDR.Union.decode_xdr!(union)
end

defmodule SCPStatementType do
  @behaviour XDR.Declaration

  defstruct declarations: nil, identifier: nil

  @scp_statement_type [
    SCP_ST_PREPARE: 0,
    SCP_ST_CONFIRM: 1,
    SCP_ST_EXTERNALIZE: 2,
    SCP_ST_NOMINATE: 3
  ]

  def new(identifier),
    do: %SCPStatementType{declarations: @scp_statement_type, identifier: identifier}

  @impl XDR.Declaration
  defdelegate encode_xdr(enum), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate encode_xdr!(enum), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate decode_xdr(enum), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate decode_xdr!(enum), to: XDR.Enum
end