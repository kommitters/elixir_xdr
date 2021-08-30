defmodule XDR.UnionTest do
  @moduledoc """
  Tests for the `XDR.Union` module.
  """

  use ExUnit.Case

  alias XDR.{Union, UnionError}

  describe "new" do
    test "with Enum" do
      enum = %{
        declarations: [
          SCP_ST_PREPARE: 0,
          SCP_ST_CONFIRM: 1,
          SCP_ST_EXTERNALIZE: 2,
          SCP_ST_NOMINATE: 3
        ],
        identifier: :SCP_ST_NOMINATE
      }

      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      expected_union = %XDR.Union{
        arms: [
          SCP_ST_PREPARE: %XDR.Int{datum: 60},
          SCP_ST_CONFIRM: %XDR.String{max_length: 4_294_967_295, string: "Confirm"},
          SCP_ST_EXTERNALIZE: %XDR.Bool{declarations: [false: 0, true: 1], identifier: false},
          SCP_ST_NOMINATE: %XDR.Float{float: 3.46}
        ],
        discriminant: %{
          declarations: [
            SCP_ST_PREPARE: 0,
            SCP_ST_CONFIRM: 1,
            SCP_ST_EXTERNALIZE: 2,
            SCP_ST_NOMINATE: 3
          ],
          identifier: :SCP_ST_NOMINATE
        },
        value: nil
      }

      assert Union.new(enum, arms) == expected_union
    end

    test "with number map" do
      arms = %{0 => XDR.Int, 1 => XDR.String, 2 => XDR.Bool, 3 => XDR.Float}

      expected_union = %XDR.Union{
        value: true,
        arms: %{0 => XDR.Int, 1 => XDR.String, 2 => XDR.Bool, 3 => XDR.Float},
        discriminant: %XDR.Int{datum: 4}
      }

      assert XDR.Int.new(4) |> Union.new(arms, true) == expected_union
    end
  end

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

      {status, reason} = Union.encode_xdr(%{discriminant: enum, arms: arms})

      assert status == :error
      assert reason == :not_atom
    end

    test "Enum example" do
      {status, result} =
        UnionSCPStatementType.new(:SCP_ST_PREPARE)
        # It also can use the XDR.UnionEnum.decode_xdr()/1 function
        |> Union.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 0, 60>>
    end

    test "encode_xdr! Enum example" do
      result =
        UnionSCPStatementType.new(:SCP_ST_CONFIRM)
        # It also can use the XDR.UnionEnum.decode_xdr()/1 function
        |> Union.encode_xdr!()

      assert result == <<0, 0, 0, 1, 0, 0, 0, 7, 67, 111, 110, 102, 105, 114, 109, 0>>
    end

    test "encode_xdr! with a custom implementation" do
      arms = [NONE: XDR.Void, TEST: XDR.String]

      result =
        CustomUnionType.new(:TEST)
        |> XDR.Union.new(arms, XDR.String.new("Confirm"))
        |> XDR.Union.encode_xdr!()

      assert result == <<0, 0, 0, 1, 0, 0, 0, 7, 67, 111, 110, 102, 105, 114, 109, 0>>
    end

    test "encode_xdr! when receives an invalid identifier" do
      enum = %{
        declarations: [
          SCP_ST_PREPARE: 0,
          SCP_ST_CONFIRM: 1,
          SCP_ST_EXTERNALIZE: 2,
          SCP_ST_NOMINATE: 3
        ],
        identifier: "SCP_ST_EXTERNALIZE"
      }

      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      assert_raise UnionError, fn -> Union.encode_xdr!(%{discriminant: enum, arms: arms}) end
    end

    test "encode_xdr default arm" do
      enum = %XDR.Enum{
        declarations: [case_1: 1, case_2: 2, case_3: 3, case_4: 4],
        identifier: :case_3
      }

      arms = [case_1: XDR.Int, default: XDR.Void]

      {status, union_xdr} = enum |> Union.new(arms) |> Union.encode_xdr()

      assert status == :ok
      assert union_xdr == <<0, 0, 0, 3>>
    end

    test "Uint example" do
      {status, result} =
        UnionNumber.new(3)
        # It also can use the XDR.UnionNumber.decode_xdr()/1 function
        |> UnionNumber.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 3, 64, 93, 112, 164>>
    end

    test "encode_xdr! Uint example" do
      result =
        UnionNumber.new(3)
        # It also can use the XDR.UnionNumber.decode_xdr()/1 function
        |> UnionNumber.encode_xdr!()

      assert result == <<0, 0, 0, 3, 64, 93, 112, 164>>
    end
  end

  describe "Encoding discriminated union with types" do
    test "when receives an invalid identifier" do
      {status, reason} =
        "SCP_ST_EXTERNALIZE"
        |> UnionSCPStatementWithTypes.new()
        |> UnionSCPStatementWithTypes.encode_xdr()

      assert status == :error
      assert reason == :not_atom
    end

    test "encode_xdr! when receives an invalid identifier" do
      assert_raise UnionError, fn ->
        "SCP_ST_EXTERNALIZE"
        |> UnionSCPStatementWithTypes.new()
        |> UnionSCPStatementWithTypes.encode_xdr!()
      end
    end

    test "encode_xdr Enum example" do
      {status, result} =
        UnionSCPStatementWithTypes.new(:SCP_ST_PREPARE, 60)
        |> UnionSCPStatementWithTypes.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 0, 60>>
    end

    test "encode_xdr! Enum example" do
      result =
        UnionSCPStatementWithTypes.new(:SCP_ST_PREPARE, 60)
        |> UnionSCPStatementWithTypes.encode_xdr!()

      assert result == <<0, 0, 0, 0, 0, 0, 0, 60>>
    end

    test "encode default Uint example" do
      {status, result} = UnionNumberWithTypes.new(3, 3.46) |> UnionNumberWithTypes.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 3, 64, 93, 112, 164>>
    end

    test "encode_xdr! Uint example" do
      result = UnionNumberWithTypes.new(0, 123) |> UnionNumberWithTypes.encode_xdr!()

      assert result == <<0, 0, 0, 0, 0, 0, 0, 123>>
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

      {status, reason} =
        Union.decode_xdr([0, 0, 0, 0, 0, 0, 0, 0], %{
          discriminant: %{declarations: nil, identifier: nil},
          arms: arms
        })

      assert status == :error
      assert reason == :not_binary
    end

    test "when receives an invalid declarations" do
      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      {status, reason} =
        Union.decode_xdr(<<0, 0, 0, 0, 0, 0, 0, 0>>, %{
          discriminant: %{declarations: nil},
          arms: arms
        })

      assert status == :error
      assert reason == :not_list
    end

    test "when receives an invalid binary" do
      arms = %{
        0 => XDR.Int.new(60),
        1 => XDR.String.new("Confirm"),
        2 => XDR.Bool.new(false),
        3 => XDR.Float.new(3.46)
      }

      {status, reason} =
        Union.decode_xdr([0, 0, 0, 3, 64, 93, 112, 164], %{
          discriminant: XDR.UInt.new(nil),
          arms: arms,
          struct: %{discriminant: XDR.UInt}
        })

      assert status == :error
      assert reason == :not_binary
    end

    test "Enum example" do
      # It also can use the XDR.UnionEnum.decode_xdr()/1 function
      {status, result} = UnionSCPStatementType.decode_xdr(<<0, 0, 0, 0, 0, 0, 0, 60>>)

      assert status == :ok

      assert result ==
               {{%XDR.Enum{
                   declarations: [
                     SCP_ST_PREPARE: 0,
                     SCP_ST_CONFIRM: 1,
                     SCP_ST_EXTERNALIZE: 2,
                     SCP_ST_NOMINATE: 3
                   ],
                   identifier: :SCP_ST_PREPARE
                 }, %XDR.Int{datum: 60}}, ""}
    end

    test "decode_xdr! with Enum example" do
      # It also can use the XDR.UnionEnum.decode_xdr()/1 function
      result = UnionSCPStatementType.decode_xdr!(<<0, 0, 0, 0, 0, 0, 0, 60>>)

      assert result ==
               {{%XDR.Enum{
                   declarations: [
                     SCP_ST_PREPARE: 0,
                     SCP_ST_CONFIRM: 1,
                     SCP_ST_EXTERNALIZE: 2,
                     SCP_ST_NOMINATE: 3
                   ],
                   identifier: :SCP_ST_PREPARE
                 }, %XDR.Int{datum: 60}}, ""}
    end

    test "decode_xdr default arm" do
      declarations = [case_1: 1, case_2: 2, case_3: 3, case_4: 4]
      enum_spec = %XDR.Enum{declarations: declarations}

      arms = [case_1: XDR.Int, default: XDR.Void]
      union_spec = Union.new(enum_spec, arms)

      {status, union} = Union.decode_xdr(<<0, 0, 0, 3>>, union_spec)

      assert status == :ok
      assert union == {{%XDR.Enum{declarations: declarations, identifier: :case_3}, nil}, ""}
    end

    test "Uint example" do
      # It also can use the XDR.UnionNumber.decode_xdr()/1 function
      {status, result} = UnionNumber.decode_xdr(<<0, 0, 0, 3, 64, 93, 112, 164>>)

      assert status == :ok
      assert result == {{3, %XDR.Float{float: 3.4600000381469727}}, ""}
    end

    test "decode_xdr! with Uint Example" do
      result = UnionNumber.decode_xdr!(<<0, 0, 0, 3, 64, 93, 112, 164>>)

      assert result == {{3, %XDR.Float{float: 3.4600000381469727}}, ""}
    end

    test "decode_xdr! with a custom implementation" do
      arms = [NONE: XDR.Void, TEST: XDR.String]
      type = CustomUnionType.new(:TEST)
      spec = XDR.Union.new(type, arms)
      value = XDR.String.new("Confirm")

      result =
        XDR.Union.decode_xdr!(
          <<0, 0, 0, 1, 0, 0, 0, 7, 67, 111, 110, 102, 105, 114, 109, 0>>,
          spec
        )

      assert result == {{type, value}, ""}
    end

    test "decode_xdr! when receives an invalid identifier" do
      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      enum = %{
        discriminant: %{declarations: nil, identifier: nil},
        arms: arms
      }

      assert_raise UnionError, fn -> Union.decode_xdr!([0, 0, 0, 0, 0, 0, 0, 0], enum) end
    end
  end

  describe "Decoding Discriminated Union with types" do
    setup do
      %{
        decoded_enum: %XDR.Enum{
          declarations: [
            SCP_ST_PREPARE: 0,
            SCP_ST_CONFIRM: 1,
            SCP_ST_EXTERNALIZE: 2,
            SCP_ST_NOMINATE: 3
          ],
          identifier: :SCP_ST_PREPARE
        }
      }
    end

    test "when receives an invalid identifier" do
      {status, reason} = UnionSCPStatementWithTypes.decode_xdr([0, 0, 0, 0, 0, 0, 0, 0])

      assert status == :error
      assert reason == :not_binary
    end

    test "when receives an invalid declarations" do
      {status, reason} =
        UnionSCPStatementWithTypes.decode_xdr(<<0, 0, 0, 0, 0, 0, 0, 0>>, %{
          discriminant: %{declarations: nil},
          arms: []
        })

      assert status == :error
      assert reason == :not_list
    end

    test "when receives an invalid binary" do
      {status, reason} = UnionNumberWithTypes.decode_xdr([0, 0, 0, 3, 64, 93, 112, 164])

      assert status == :error
      assert reason == :not_binary
    end

    test "decode_xdr/1 with an invalid arm", %{decoded_enum: decoded_enum} do
      arms = [case_1: %XDR.Int{datum: 1}, case_2: %XDR.Int{datum: 2}]

      {status, reason} =
        XDR.Union.decode_xdr(<<0, 0, 0, 2, 0, 93, 112, 164>>, XDR.Union.new(decoded_enum, arms))

      assert status == :error
      assert reason == :invalid_arm
    end

    test "Enum example", %{decoded_enum: decoded_enum} do
      {status, result} = UnionSCPStatementWithTypes.decode_xdr(<<0, 0, 0, 0, 0, 0, 0, 60>>)

      assert status == :ok
      assert result == {{decoded_enum, %XDR.Int{datum: 60}}, ""}
    end

    test "decode_xdr! with Enum example", %{decoded_enum: decoded_enum} do
      result = UnionSCPStatementWithTypes.decode_xdr!(<<0, 0, 0, 0, 0, 0, 0, 60>>)

      assert result == {{decoded_enum, %XDR.Int{datum: 60}}, ""}
    end

    test "decode default Uint example" do
      {status, result} = UnionNumberWithTypes.decode_xdr(<<0, 0, 0, 3, 64, 93, 112, 164>>)

      assert status == :ok
      assert result == {{3, %XDR.Float{float: 3.4600000381469727}}, ""}
    end

    test "decode_xdr! with Uint Example" do
      result = UnionNumberWithTypes.decode_xdr!(<<0, 0, 0, 0, 0, 0, 0, 123>>)

      assert result == {{0, %XDR.Int{datum: 123}}, ""}
    end
  end
end

defmodule UnionSCPStatementType do
  @behaviour XDR.Declaration

  defstruct discriminant: XDR.Enum, arms: nil, struct: nil, value: nil

  @arms [
    SCP_ST_PREPARE: XDR.Int.new(60),
    SCP_ST_CONFIRM: XDR.String.new("Confirm"),
    SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
    SCP_ST_NOMINATE: XDR.Float.new(3.46)
  ]

  def new(identifier),
    do: %UnionSCPStatementType{
      discriminant: SCPStatementType.new(identifier),
      arms: @arms
    }

  @impl XDR.Declaration
  def encode_xdr(%UnionSCPStatementType{} = union), do: XDR.Union.encode_xdr(union)

  @impl XDR.Declaration
  def encode_xdr!(%UnionSCPStatementType{} = union), do: encode_xdr(union) |> elem(1)

  @impl XDR.Declaration
  def decode_xdr(bytes, union \\ new(nil))
  def decode_xdr(bytes, %UnionSCPStatementType{} = union), do: XDR.Union.decode_xdr(bytes, union)

  @impl XDR.Declaration
  def decode_xdr!(bytes, union \\ new(nil))

  def decode_xdr!(bytes, %UnionSCPStatementType{} = union),
    do: XDR.Union.decode_xdr!(bytes, union)
end

defmodule UnionNumber do
  @behaviour XDR.Declaration

  defstruct discriminant: XDR.UInt, arms: nil, struct: nil, value: nil

  @arms %{
    0 => XDR.Int.new(60),
    1 => XDR.String.new("Confirm"),
    2 => XDR.Bool.new(false),
    3 => XDR.Float.new(3.46)
  }

  def new(identifier),
    do: %UnionNumber{
      discriminant: XDR.UInt.new(identifier),
      arms: @arms
    }

  @impl XDR.Declaration
  def encode_xdr(%UnionNumber{} = union), do: XDR.Union.encode_xdr(union)
  @impl XDR.Declaration
  def encode_xdr!(%UnionNumber{} = union), do: XDR.Union.encode_xdr!(union)
  @impl XDR.Declaration
  def decode_xdr(bytes, union \\ new(nil))
  def decode_xdr(bytes, %UnionNumber{} = union), do: XDR.Union.decode_xdr(bytes, union)
  @impl XDR.Declaration
  def decode_xdr!(bytes, union \\ new(nil))
  def decode_xdr!(bytes, %UnionNumber{} = union), do: XDR.Union.decode_xdr!(bytes, union)
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

  @spec new(identifier :: atom()) :: %__MODULE__{}
  def new(identifier),
    do: %SCPStatementType{declarations: @scp_statement_type, identifier: identifier}

  @impl XDR.Declaration
  defdelegate encode_xdr(enum), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate encode_xdr!(enum), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate decode_xdr(bytes, struct), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate decode_xdr!(bytes, struct), to: XDR.Enum
end

defmodule UnionNumberWithTypes do
  @arms %{
    0 => XDR.Int,
    1 => XDR.String,
    2 => XDR.Bool,
    :default => XDR.Float
  }

  def new(identifier, value \\ nil) do
    identifier |> XDR.UInt.new() |> XDR.Union.new(@arms, value)
  end

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  def encode_xdr(union), do: XDR.Union.encode_xdr(union)

  @impl XDR.Declaration
  def encode_xdr!(union), do: XDR.Union.encode_xdr!(union)

  @impl XDR.Declaration
  def decode_xdr(bytes, union \\ new(nil))
  def decode_xdr(bytes, union), do: XDR.Union.decode_xdr(bytes, union)

  @impl XDR.Declaration
  def decode_xdr!(bytes, union \\ new(nil))
  def decode_xdr!(bytes, union), do: XDR.Union.decode_xdr!(bytes, union)
end

defmodule UnionSCPStatementWithTypes do
  @arms [
    SCP_ST_PREPARE: XDR.Int,
    SCP_ST_CONFIRM: XDR.String,
    SCP_ST_EXTERNALIZE: XDR.Bool,
    SCP_ST_NOMINATE: XDR.Float
  ]

  @spec new(identifier :: atom(), value :: any()) :: XDR.Union.t()
  def new(identifier, value \\ nil) do
    identifier |> SCPStatementType.new() |> XDR.Union.new(@arms, value)
  end

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  def encode_xdr(union), do: XDR.Union.encode_xdr(union)

  @impl XDR.Declaration
  def encode_xdr!(union), do: XDR.Union.encode_xdr!(union)

  @impl XDR.Declaration
  def decode_xdr(bytes, union \\ new(nil))
  def decode_xdr(bytes, union), do: XDR.Union.decode_xdr(bytes, union)

  @impl XDR.Declaration
  def decode_xdr!(bytes, union \\ new(nil))
  def decode_xdr!(bytes, union), do: XDR.Union.decode_xdr!(bytes, union)
end

defmodule CustomUnionType do
  @behaviour XDR.Declaration

  @declarations [NONE: 0, TEST: 1]

  @enum_spec %XDR.Enum{declarations: @declarations, identifier: nil}

  defstruct [:identifier]

  def new(identifier \\ :NONE), do: %__MODULE__{identifier: identifier}

  @impl XDR.Declaration
  def encode_xdr(%__MODULE__{identifier: identifier}),
    do: XDR.Enum.encode_xdr(XDR.Enum.new(@declarations, identifier))

  @impl XDR.Declaration
  def encode_xdr!(%__MODULE__{identifier: identifier}),
    do: XDR.Enum.encode_xdr!(XDR.Enum.new(@declarations, identifier))

  @impl XDR.Declaration
  def decode_xdr(bytes, spec \\ @enum_spec) do
    case XDR.Enum.decode_xdr(bytes, spec) do
      {:ok, {%XDR.Enum{identifier: type}, rest}} -> {:ok, {new(type), rest}}
      error -> error
    end
  end

  @impl XDR.Declaration
  def decode_xdr!(bytes, spec \\ @enum_spec) do
    {%XDR.Enum{identifier: type}, rest} = XDR.Enum.decode_xdr!(bytes, spec)
    {new(type), rest}
  end
end
