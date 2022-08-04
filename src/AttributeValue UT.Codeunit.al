codeunit 50300 "AttributeValue UT Item"
{
    Subtype = Test;

    var
        Assert: Codeunit "cLibrary Assert";

    //[FEATURE] AttributeValue UT Item
    [Test]
    procedure AssignAttribute1ValueToItem()
    //[FEATURE] AttributeValue UT Item
    var
        Item: Record Item;
        AttributeValueCode: Code[10];
    begin
        //[SCENARIO #0001] Assign attribute 1 value to item

        //[GIVEN] A attribute 1 value
        AttributeValueCode := CreateAttribute1ValueCode();

        //[GIVEN] A Item
        CreateItem(Item);

        //[WHEN] Set attribute 1 value on Item
        SetAttribute1ValueOnItem(Item, AttributeValueCode);

        //[THEN] Item has attribute 1 value field populated
        VerifyAttribute1ValueOnItem(Item."No.", AttributeValueCode);
    end;

    [Test]
    procedure AssignAttribute2ValueToItem()
    //[FEATURE] AttributeValue UT Item
    var
        Item: Record Item;
        AttributeValueCode: Code[10];
    begin
        //[SCENARIO #0002] Assign attribute 2 value to item

        //[GIVEN] A attribute 2 value
        AttributeValueCode := CreateAttribute2ValueCode();

        //[GIVEN] A Item
        CreateItem(Item);

        //[WHEN] Set attribute 2 value on Item
        SetAttribute2ValueOnItem(Item, AttributeValueCode);

        //[THEN] Item has attribute 2 value field populated
        VerifyAttribute2ValueOnItem(Item."No.", AttributeValueCode);
    end;


    [Test]
    procedure AssignNonExistingAttribute1ValueToItem()
    //[FEATURE] AttributeValue UT Item
    var
        Item: Record Item;
        AttributeValueCode: Code[10];
    begin
        //[SCENARIO #0003] Assign non-existing attribute 1 value to Item

        //[GIVEN] A non-existing attribute 1 value
        AttributeValueCode := 'SC #0003';

        //[GIVEN] A Item record variable
        // See local variable Item

        //[WHEN] Set non-existing Attribute value on Item
        asserterror SetAttribute1ValueOnItem(Item, AttributeValueCode);

        //[THEN] Non existing Attribute value error thrown
        VerifyNonExistingAttribute1ValueError(AttributeValueCode);
    end;

    [Test]
    procedure AssignNonExistingAttribute2ValueToItem()
    //[FEATURE] AttributeValue UT Item
    var
        Item: Record Item;
        AttributeValueCode: Code[10];
    begin
        //[SCENARIO #0004] Assign non-existing attribute 1 value to Item

        //[GIVEN] A non-existing attribute 1 value
        AttributeValueCode := 'SC #0004';

        //[GIVEN] A Item record variable
        // See local variable Item

        //[WHEN] Set non-existing Attribute value on Item
        asserterror SetAttribute2ValueOnItem(Item, AttributeValueCode);

        //[THEN] Non existing Attribute value error thrown
        VerifyNonExistingAttribute2ValueError(AttributeValueCode);
    end;

    [Test]
    [HandlerFunctions('HandleConfigTemplates')]
    procedure AssignAttribute1ValueToItemCard()
    //[FEATURE] AttributeValue UT Item UI
    var
        ItemCard: TestPage "Item Card";
        ItemNo: Code[20];
        AttributeValueCode: Code[10];
    begin
        //[SCENARIO #0005] Assign Attribute value on Item card

        //[GIVEN] A Attribute value
        AttributeValueCode := CreateAttribute1ValueCode();
        //[GIVEN] A Item card
        CreateItemCard(ItemCard);

        //[WHEN] Set Attribute value on Item card
        ItemNo := SetAttribute1ValueOnItemCard(ItemCard, AttributeValueCode);

        //[THEN] Item has Attribute value field populated
        VerifyAttribute1ValueOnItem(ItemNo, AttributeValueCode);
    end;

    [Test]
    [HandlerFunctions('HandleConfigTemplates')]

    procedure AssignAttribute2ValueToItemCard()
    //[FEATURE] AttributeValue UT Item UI
    var
        ItemCard: TestPage "Item Card";
        ItemNo: Code[20];
        AttributeValueCode: Code[10];
    begin
        //[SCENARIO #0006] Assign Attribute value on Item card

        //[GIVEN] A Attribute value
        AttributeValueCode := CreateAttribute2ValueCode();

        //[GIVEN] A Item card
        CreateItemCard(ItemCard);

        //[WHEN] Set Attribute value on Item card
        ItemNo := SetAttribute2ValueOnItemCard(ItemCard, AttributeValueCode);

        //[THEN] Item has Attribute value field populated
        VerifyAttribute2ValueOnItem(ItemNo, AttributeValueCode);
    end;

    local procedure CreateAttribute1ValueCode(): Code[10]
    var
        Attribute: Record "Item Attribute 1";
        AttrCo: Code[20];
    begin
        AttrCo := CreateAttributeValueCode();
        Attribute.Init();
        Attribute.Validate("Item Attrib 1 Code", AttrCo);
        Attribute.Validate("Item Attrib 1 Desc", AttrCo);
        Attribute.Insert();
        exit(Attribute."Item Attrib 1 Code");
    end;

    local procedure CreateAttribute2ValueCode(): Code[10]
    var
        Attribute: Record "Item Attribute 2";
        AttrCo: Code[20];
    begin
        AttrCo := CreateAttributeValueCode();
        Attribute.Init();
        Attribute.Validate("Item Attrib 2 Code", AttrCo);
        Attribute.Validate("Item Attrib 2 Desc", AttrCo);
        Attribute.Insert();
        exit(Attribute."Item Attrib 2 Code");
    end;

    local procedure CreateAttributeValueCode(): Code[10]
    var
        AttributeValueCode: Code[20];
    begin
        Randomize();
        AttributeValueCode := StrSubstNo('AT%1', Random(100));
        exit(AttributeValueCode);
    end;

    local procedure CreateItem(var Item: record Item)
    begin
        Randomize();
        Item.init;
        item."No." := StrSubstNo('AT%1', Random(100));
        Item.Description := 'Item Attr';
        Item.Insert(true);
    end;

    local procedure SetAttribute1ValueOnItem(var Item: Record Item; AttributeValueCode: Code[10])
    begin
        Item.Validate("Attribute 1", AttributeValueCode);
        Item.Modify();
    end;

    local procedure SetAttribute2ValueOnItem(var Item: Record Item; AttributeValueCode: Code[10])
    begin
        Item.Validate("Attribute 2", AttributeValueCode);
        Item.Modify();
    end;

    local procedure CreateItemCard(var ItemCard: TestPage "Item Card")
    begin
        ItemCard.OpenNew();
    end;

    local procedure SetAttribute1ValueOnItemCard(var ItemCard: TestPage "Item Card"; AttributeValueCode: Code[10]) ItemNo: Code[20]
    begin
        Assert.IsTrue(ItemCard."Attribute 1".Editable(), 'Editable');
        ItemCard."Attribute 1".SetValue(AttributeValueCode);
        ItemNo := ItemCard."No.".Value();
        ItemCard.Close();
    end;

    local procedure SetAttribute2ValueOnItemCard(var ItemCard: TestPage "Item Card"; AttributeValueCode: Code[10]) ItemNo: Code[20]
    begin
        Assert.IsTrue(ItemCard."Attribute 1".Editable(), 'Editable');
        ItemCard."Attribute 2".SetValue(AttributeValueCode);
        ItemNo := ItemCard."No.".Value();
        ItemCard.Close();
    end;

    local procedure VerifyAttribute1ValueOnItem(ItemNo: Code[20]; AttributeValueCode: Code[10])
    var
        Item: Record Item;
        FieldOnTableTxt: Label '%1 on %2';
    begin
        Item.Get(ItemNo);
        Assert.AreEqual(
            AttributeValueCode,
            Item."Attribute 1",
            StrSubstNo(
                FieldOnTableTxt,
                Item.FieldCaption("Attribute 1"),
                Item.TableCaption())
            );
    end;

    local procedure VerifyAttribute2ValueOnItem(ItemNo: Code[20]; AttributeValueCode: Code[10])
    var
        Item: Record Item;
        FieldOnTableTxt: Label '%1 on %2';
    begin
        Item.Get(ItemNo);
        Assert.AreEqual(
            AttributeValueCode,
            Item."Attribute 2",
            StrSubstNo(
                FieldOnTableTxt,
                Item.FieldCaption("Attribute 1"),
                Item.TableCaption())
            );
    end;

    local procedure VerifyNonExistingAttribute1ValueError(AttributeValueCode: Code[10])
    var
        Item: Record Item;
        AttributeValue: Record "Item Attribute 1";
        ValueCannotBeFoundInTableTxt: Label 'The field %1 of table %2 contains a value (%3) that cannot be found in the related table (%4).';
    begin
        Assert.ExpectedError(
            StrSubstNo(
                ValueCannotBeFoundInTableTxt,
                Item.FieldCaption("Attribute 1"),
                Item.TableCaption(),
                AttributeValueCode,
                AttributeValue.TableCaption()));
    end;

    local procedure VerifyNonExistingAttribute2ValueError(AttributeValueCode: Code[10])
    var
        Item: Record Item;
        AttributeValue: Record "Item Attribute 2";
        ValueCannotBeFoundInTableTxt: Label 'The field %1 of table %2 contains a value (%3) that cannot be found in the related table (%4).';
    begin
        Assert.ExpectedError(
            StrSubstNo(
                ValueCannotBeFoundInTableTxt,
                Item.FieldCaption("Attribute 2"),
                Item.TableCaption(),
                AttributeValueCode,
                AttributeValue.TableCaption()));
    end;

    [ModalPageHandler]
    procedure HandleConfigTemplates(var ConfigTemplates: TestPage "Config Templates")
    begin
        ConfigTemplates.OK.Invoke();
    end;
}