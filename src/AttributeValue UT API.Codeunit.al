codeunit 50302 "AttributeValue UT API"
{
    Subtype = Test;

    var
        Assert: Codeunit "cLibrary Assert";

    //[FEATURE] AttributeValue UT Item
    [Test]
    [HandlerFunctions('ConfirmationHandler')]
    procedure AddAttribute1ValueSOAP()
    //[FEATURE] AttributeValue UT Item
    var
        AttributeValueCode: Code[10];
    begin
        //[SCENARIO #0001] Add attribute 1 

        //[GIVEN] A attribute 1 value
        AttributeValueCode := CreateAttributeValueCode();

        //[WHEN] attribute 1 value added via soap
        AddAttributeValueSOAP(1, AttributeValueCode);

        //[THEN] attribute 1 value exists
        VerifyAttribute1Value(AttributeValueCode);

        //[TEARDOWN] Remove attribute 1 value
        RemoveAttribute1Value(AttributeValueCode);
    end;
    //[FEATURE] AttributeValue UT Item
    [Test]
    [HandlerFunctions('ConfirmationHandler')]
    procedure AddAttribute2ValueSOAP()
    //[FEATURE] AttributeValue UT Item
    var
        AttributeValueCode: Code[10];
    begin
        //[SCENARIO #0001] Add attribute 1 

        //[GIVEN] A attribute 2 value
        AttributeValueCode := CreateAttributeValueCode();

        //[WHEN] attribute 2 value added via soap
        AddAttributeValueSOAP(2, AttributeValueCode);

        //[THEN] attribute 2 value exists
        VerifyAttribute2Value(AttributeValueCode);

        //[TEARDOWN] Remove attribute 2 value
        RemoveAttribute2Value(AttributeValueCode);
    end;

    local procedure CreateAttributeValueCode(): Code[10]
    var
        AttributeValueCode: Code[20];
    begin
        Randomize();
        AttributeValueCode := StrSubstNo('AT%1', Random(100));
        exit(AttributeValueCode);
    end;

    local procedure VerifyAttribute1Value(AttributeValueCode: Code[10])
    var
        Attribute: Record "Item Attribute 1";
    begin
        Attribute.Get(AttributeValueCode);
    end;

    local procedure VerifyAttribute2Value(AttributeValueCode: Code[10])
    var
        Attribute: Record "Item Attribute 2";
    begin
        Attribute.Get(AttributeValueCode);
    end;

    local procedure RemoveAttribute1Value(AttributeValueCode: Code[10])
    var
        Attribute: Record "Item Attribute 1";
    begin
        Attribute.Get(AttributeValueCode);
        Attribute.Delete();
    end;

    local procedure RemoveAttribute2Value(AttributeValueCode: Code[10])
    var
        Attribute: Record "Item Attribute 2";
    begin
        Attribute.Get(AttributeValueCode);
        Attribute.Delete();
    end;

    local procedure AddAttributeValueSOAP(AttributeNo: Integer; AttributeValueCode: Code[10])
    var
        responseTxt: Text;
        HttpStatusCode: Integer;
    begin
        HttpStatusCode := HttpPost(SOAPData(AttributeNo, AttributeValueCode), responseTxt);
        Assert.AreEqual(HttpStatusCode, 200, 'Http code should be 200');
    end;


    local procedure HttpPost(postDataTxt: Text; var responseTxt: Text): Integer;
    var
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        AuthString: Text;
        Converter: Codeunit "Base64 Convert";
        postUrl: Label 'https://ed2e078a5ab0:7047/BC/WS/CRONUS/Codeunit/AddItemAttributes';
    begin
        //Create Basic auth string 
        AuthString := STRSUBSTNO('%1:%2', 'Admin', 'Feze1205');
        AuthString := Converter.ToBase64(AuthString);
        AuthString := STRSUBSTNO('Basic %1', AuthString);

        HttpContent.WriteFrom(postDataTxt);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'text/xml;charset=UTF-8');
        HttpHeaders.Remove('SOAPAction');
        HttpHeaders.Add('SOAPAction', '');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
        HttpClient.Post(postUrl, HttpContent, HttpResponseMessage);
        HttpResponseMessage.Content.ReadAs(responseTxt);
        exit(HttpResponseMessage.HttpStatusCode);
    end;

    local procedure SOAPData(AttributeNo: Integer; AttributeValueCode: Code[10]): Text
    var
        SOAPXML: Text;
    begin
        SOAPXML := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:add="urn:microsoft-dynamics-schemas/codeunit/AddItemAttributes" xmlns:add1="urn:microsoft-dynamics-nav/AddItemAttribute">'
                    + '<soapenv:Header/>'
                    + '<soapenv:Body>'
                        + '<add:AddAtribute%1>'
                            + '<add:attribute>'
                                + '<add1:ItemAttribute Code="%2" Description="%3"/>'
                            + '</add:attribute>'
                        + '</add:AddAtribute%1>'
                    + '</soapenv:Body>'
                    + '</soapenv:Envelope>';
        exit(StrSubstNo(SOAPXML, AttributeNo, AttributeValueCode, AttributeValueCode));
    end;

    [StrMenuHandler]
    procedure ConfirmationHandler(Options: Text[1024]; var Choice: Integer; Instruction: Text[1024])
    var
        myInt: Integer;
    begin
        Choice := 2;
    end;
}