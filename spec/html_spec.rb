require 'spec_helper'
require 'nokogiri'

describe XPath::HTML do
  let(:template) { 'form' }
  let(:template_path) { File.read(File.expand_path("fixtures/#{template}.html", File.dirname(__FILE__))) }
  let(:doc) { Nokogiri::HTML(template_path) }

  def get(example, *args)
    all(example, *args).first
  end

  def all(example, *args)
    type = example.metadata[:type]
    doc.xpath(XPath::HTML.send(subject, *args).to_xpath(type)).map { |node| node[:data] }
  end

  describe '#link' do
    subject { :link }

    it("finds links by id")                                { |example| get(example, 'some-id').should == 'link-id' }
    it("finds links by content")                           { |example| get(example, 'An awesome link').should == 'link-text' }
    it("finds links by content regardless of whitespace")  { |example| get(example, 'My whitespaced link').should == 'link-whitespace' }
    it("finds links with child tags by content")           { |example| get(example, 'An emphatic link').should == 'link-children' }
    it("finds links by the content of their child tags")   { |example| get(example, 'emphatic').should == 'link-children' }
    it("finds links by approximate content")               { |example| get(example, 'awesome').should == 'link-text' }
    it("finds links by title")                             { |example| get(example, 'My title').should == 'link-title' }
    it("finds links by approximate title")                 { |example| get(example, 'title').should == 'link-title' }
    it("finds links by image's alt attribute")             { |example| get(example, 'Alt link').should == 'link-img' }
    it("finds links by image's approximate alt attribute") { |example| get(example, 'Alt').should == 'link-img' }
    it("does not find links without href attriutes")       { |example| get(example, 'Wrong Link').should be_nil }
    it("casts to string")                                  { |example| get(example, :'some-id').should == 'link-id' }

    context "with exact match", :type => :exact do
      it("finds links by content")                                   { |example| get(example, 'An awesome link').should == 'link-text' }
      it("does not find links by approximate content")               { |example| get(example, 'awesome').should be_nil }
      it("finds links by title")                                     { |example| get(example, 'My title').should == 'link-title' }
      it("does not find links by approximate title")                 { |example| get(example, 'title').should be_nil }
      it("finds links by image's alt attribute")                     { |example| get(example, 'Alt link').should == 'link-img' }
      it("does not find links by image's approximate alt attribute") { |example| get(example, 'Alt').should be_nil }
    end
  end

  describe '#button' do
    subject { :button }

    context "with submit type" do
      it("finds buttons by id")                { |example| get(example, 'submit-with-id').should == 'id-submit' }
      it("finds buttons by value")             { |example| get(example, 'submit-with-value').should == 'value-submit' }
      it("finds buttons by approximate value") { |example| get(example, 'mit-with-val').should == 'value-submit' }
      it("finds buttons by title")             { |example| get(example, 'My submit title').should == 'title-submit' }
      it("finds buttons by approximate title") { |example| get(example, 'submit title').should == 'title-submit' }

      context "with exact match", :type => :exact do
        it("finds buttons by value")                     { |example| get(example, 'submit-with-value').should == 'value-submit' }
        it("does not find buttons by approximate value") { |example| get(example, 'mit-with-val').should be_nil }
        it("finds buttons by title")                     { |example| get(example, 'My submit title').should == 'title-submit' }
        it("does not find buttons by approximate title") { |example| get(example, 'submit title').should be_nil }
      end
    end

    context "with reset type" do
      it("finds buttons by id")                { |example| get(example, 'reset-with-id').should == 'id-reset' }
      it("finds buttons by value")             { |example| get(example, 'reset-with-value').should == 'value-reset' }
      it("finds buttons by approximate value") { |example| get(example, 'set-with-val').should == 'value-reset' }
      it("finds buttons by title")             { |example| get(example, 'My reset title').should == 'title-reset' }
      it("finds buttons by approximate title") { |example| get(example, 'reset title').should == 'title-reset' }

      context "with exact match", :type => :exact do
        it("finds buttons by value")                     { |example| get(example, 'reset-with-value').should == 'value-reset' }
        it("does not find buttons by approximate value") { |example| get(example, 'set-with-val').should be_nil }
        it("finds buttons by title")                     { |example| get(example, 'My reset title').should == 'title-reset' }
        it("does not find buttons by approximate title") { |example| get(example, 'reset title').should be_nil }
      end
    end

    context "with button type" do
      it("finds buttons by id")                { |example| get(example, 'button-with-id').should == 'id-button' }
      it("finds buttons by value")             { |example| get(example, 'button-with-value').should == 'value-button' }
      it("finds buttons by approximate value") { |example| get(example, 'ton-with-val').should == 'value-button' }
      it("finds buttons by title")             { |example| get(example, 'My button title').should == 'title-button' }
      it("finds buttons by approximate title") { |example| get(example, 'button title').should == 'title-button' }

      context "with exact match", :type => :exact do
        it("finds buttons by value")                     { |example| get(example, 'button-with-value').should == 'value-button' }
        it("does not find buttons by approximate value") { |example| get(example, 'ton-with-val').should be_nil }
        it("finds buttons by title")                     { |example| get(example, 'My button title').should == 'title-button' }
        it("does not find buttons by approximate title") { |example| get(example, 'button title').should be_nil }
      end
    end

    context "with image type" do
      it("finds buttons by id")                        { |example| get(example, 'imgbut-with-id').should == 'id-imgbut' }
      it("finds buttons by value")                     { |example| get(example, 'imgbut-with-value').should == 'value-imgbut' }
      it("finds buttons by approximate value")         { |example| get(example, 'gbut-with-val').should == 'value-imgbut' }
      it("finds buttons by alt attribute")             { |example| get(example, 'imgbut-with-alt').should == 'alt-imgbut' }
      it("finds buttons by approximate alt attribute") { |example| get(example, 'mgbut-with-al').should == 'alt-imgbut' }
      it("finds buttons by title")                     { |example| get(example, 'My imgbut title').should == 'title-imgbut' }
      it("finds buttons by approximate title")         { |example| get(example, 'imgbut title').should == 'title-imgbut' }

      context "with exact match", :type => :exact do
        it("finds buttons by value")                             { |example| get(example, 'imgbut-with-value').should == 'value-imgbut' }
        it("does not find buttons by approximate value")         { |example| get(example, 'gbut-with-val').should be_nil }
        it("finds buttons by alt attribute")                     { |example| get(example, 'imgbut-with-alt').should == 'alt-imgbut' }
        it("does not find buttons by approximate alt attribute") { |example| get(example, 'mgbut-with-al').should be_nil }
        it("finds buttons by title")                             { |example| get(example, 'My imgbut title').should == 'title-imgbut' }
        it("does not find buttons by approximate title")         { |example| get(example, 'imgbut title').should be_nil }
      end
    end

    context "with button tag" do
      it("finds buttons by id")                       { |example| get(example, 'btag-with-id').should == 'id-btag' }
      it("finds buttons by value")                    { |example| get(example, 'btag-with-value').should == 'value-btag' }
      it("finds buttons by approximate value")        { |example| get(example, 'tag-with-val').should == 'value-btag' }
      it("finds buttons by text")                     { |example| get(example, 'btag-with-text').should == 'text-btag' }
      it("finds buttons by text ignoring whitespace") { |example| get(example, 'My whitespaced button').should == 'btag-with-whitespace' }
      it("finds buttons by approximate text ")        { |example| get(example, 'tag-with-tex').should == 'text-btag' }
      it("finds buttons with child tags by text")     { |example| get(example, 'An emphatic button').should == 'btag-with-children' }
      it("finds buttons by text of their children")   { |example| get(example, 'emphatic').should == 'btag-with-children' }
      it("finds buttons by title")                    { |example| get(example, 'My btag title').should == 'title-btag' }
      it("finds buttons by approximate title")        { |example| get(example, 'btag title').should == 'title-btag' }

      context "with exact match", :type => :exact do
        it("finds buttons by value")                     { |example| get(example, 'btag-with-value').should == 'value-btag' }
        it("does not find buttons by approximate value") { |example| get(example, 'tag-with-val').should be_nil }
        it("finds buttons by text")                      { |example| get(example, 'btag-with-text').should == 'text-btag' }
        it("does not find buttons by approximate text ") { |example| get(example, 'tag-with-tex').should be_nil }
        it("finds buttons by title")                     { |example| get(example, 'My btag title').should == 'title-btag' }
        it("does not find buttons by approximate title") { |example| get(example, 'btag title').should be_nil }
      end
    end

    context "with unkown type" do
      it("does not find the button") { |example| get(example, 'schmoo button').should be_nil }
    end

    it("casts to string") { |example| get(example, :'tag-with-tex').should == 'text-btag' }
  end

  describe '#fieldset' do
    subject { :fieldset }

    it("finds fieldsets by id")                  { |example| get(example, 'some-fieldset-id').should == 'fieldset-id' }
    it("finds fieldsets by legend")              { |example| get(example, 'Some Legend').should == 'fieldset-legend' }
    it("finds fieldsets by legend child tags")   { |example| get(example, 'Span Legend').should == 'fieldset-legend-span' }
    it("accepts approximate legends")            { |example| get(example, 'Legend').should == 'fieldset-legend' }
    it("finds nested fieldsets by legend")       { |example| get(example, 'Inner legend').should == 'fieldset-inner' }
    it("casts to string")                        { |example| get(example, :'Inner legend').should == 'fieldset-inner' }

    context "with exact match", :type => :exact do
      it("finds fieldsets by legend")            { |example| get(example, 'Some Legend').should == 'fieldset-legend' }
      it("does not find by approximate legends") { |example| get(example, 'Legend').should be_nil }
    end
  end

  describe '#field' do
    subject { :field }

    context "by id" do
      it("finds inputs with no type")       { |example| get(example, 'input-with-id').should == 'input-with-id-data' }
      it("finds inputs with text type")     { |example| get(example, 'input-text-with-id').should == 'input-text-with-id-data' }
      it("finds inputs with password type") { |example| get(example, 'input-password-with-id').should == 'input-password-with-id-data' }
      it("finds inputs with custom type")   { |example| get(example, 'input-custom-with-id').should == 'input-custom-with-id-data' }
      it("finds textareas")                 { |example| get(example, 'textarea-with-id').should == 'textarea-with-id-data' }
      it("finds select boxes")              { |example| get(example, 'select-with-id').should == 'select-with-id-data' }
      it("does not find submit buttons")    { |example| get(example, 'input-submit-with-id').should be_nil }
      it("does not find image buttons")     { |example| get(example, 'input-image-with-id').should be_nil }
      it("does not find hidden fields")     { |example| get(example, 'input-hidden-with-id').should be_nil }
    end

    context "by name" do
      it("finds inputs with no type")       { |example| get(example, 'input-with-name').should == 'input-with-name-data' }
      it("finds inputs with text type")     { |example| get(example, 'input-text-with-name').should == 'input-text-with-name-data' }
      it("finds inputs with password type") { |example| get(example, 'input-password-with-name').should == 'input-password-with-name-data' }
      it("finds inputs with custom type")   { |example| get(example, 'input-custom-with-name').should == 'input-custom-with-name-data' }
      it("finds textareas")                 { |example| get(example, 'textarea-with-name').should == 'textarea-with-name-data' }
      it("finds select boxes")              { |example| get(example, 'select-with-name').should == 'select-with-name-data' }
      it("does not find submit buttons")    { |example| get(example, 'input-submit-with-name').should be_nil }
      it("does not find image buttons")     { |example| get(example, 'input-image-with-name').should be_nil }
      it("does not find hidden fields")     { |example| get(example, 'input-hidden-with-name').should be_nil }
    end

    context "by placeholder" do
      it("finds inputs with no type")       { |example| get(example, 'input-with-placeholder').should == 'input-with-placeholder-data' }
      it("finds inputs with text type")     { |example| get(example, 'input-text-with-placeholder').should == 'input-text-with-placeholder-data' }
      it("finds inputs with password type") { |example| get(example, 'input-password-with-placeholder').should == 'input-password-with-placeholder-data' }
      it("finds inputs with custom type")   { |example| get(example, 'input-custom-with-placeholder').should == 'input-custom-with-placeholder-data' }
      it("finds textareas")                 { |example| get(example, 'textarea-with-placeholder').should == 'textarea-with-placeholder-data' }
      it("does not find hidden fields")     { |example| get(example, 'input-hidden-with-placeholder').should be_nil }
    end

    context "by referenced label" do
      it("finds inputs with no type")       { |example| get(example, 'Input with label').should == 'input-with-label-data' }
      it("finds inputs with text type")     { |example| get(example, 'Input text with label').should == 'input-text-with-label-data' }
      it("finds inputs with password type") { |example| get(example, 'Input password with label').should == 'input-password-with-label-data' }
      it("finds inputs with custom type")   { |example| get(example, 'Input custom with label').should == 'input-custom-with-label-data' }
      it("finds textareas")                 { |example| get(example, 'Textarea with label').should == 'textarea-with-label-data' }
      it("finds select boxes")              { |example| get(example, 'Select with label').should == 'select-with-label-data' }
      it("does not find submit buttons")    { |example| get(example, 'Input submit with label').should be_nil }
      it("does not find image buttons")     { |example| get(example, 'Input image with label').should be_nil }
      it("does not find hidden fields")     { |example| get(example, 'Input hidden with label').should be_nil }
    end

    context "by parent label" do
      it("finds inputs with no type")       { |example| get(example, 'Input with parent label').should == 'input-with-parent-label-data' }
      it("finds inputs with text type")     { |example| get(example, 'Input text with parent label').should == 'input-text-with-parent-label-data' }
      it("finds inputs with password type") { |example| get(example, 'Input password with parent label').should == 'input-password-with-parent-label-data' }
      it("finds inputs with custom type")   { |example| get(example, 'Input custom with parent label').should == 'input-custom-with-parent-label-data' }
      it("finds textareas")                 { |example| get(example, 'Textarea with parent label').should == 'textarea-with-parent-label-data' }
      it("finds select boxes")              { |example| get(example, 'Select with parent label').should == 'select-with-parent-label-data' }
      it("does not find submit buttons")    { |example| get(example, 'Input submit with parent label').should be_nil }
      it("does not find image buttons")     { |example| get(example, 'Input image with parent label').should be_nil }
      it("does not find hidden fields")     { |example| get(example, 'Input hidden with parent label').should be_nil }
    end

    it("casts to string") { |example| get(example, :'select-with-id').should == 'select-with-id-data' }
  end

  describe '#fillable_field' do
    subject{ :fillable_field }
    context "by parent label" do
      it("finds inputs with text type")                    { |example| get(example, 'Label text').should == 'id-text' }
      it("finds inputs where label has problem chars")     { |example| get(example, "Label text's got an apostrophe").should == 'id-problem-text' }
    end

  end

  describe '#select' do
    subject{ :select }
    it("finds selects by id")             { |example| get(example, 'select-with-id').should == 'select-with-id-data' }
    it("finds selects by name")           { |example| get(example, 'select-with-name').should == 'select-with-name-data' }
    it("finds selects by label")          { |example| get(example, 'Select with label').should == 'select-with-label-data' }
    it("finds selects by parent label")   { |example| get(example, 'Select with parent label').should == 'select-with-parent-label-data' }
    it("casts to string")                 { |example| get(example, :'Select with parent label').should == 'select-with-parent-label-data' }
  end

  describe '#checkbox' do
    subject{ :checkbox }
    it("finds checkboxes by id")           { |example| get(example, 'input-checkbox-with-id').should == 'input-checkbox-with-id-data' }
    it("finds checkboxes by name")         { |example| get(example, 'input-checkbox-with-name').should == 'input-checkbox-with-name-data' }
    it("finds checkboxes by label")        { |example| get(example, 'Input checkbox with label').should == 'input-checkbox-with-label-data' }
    it("finds checkboxes by parent label") { |example| get(example, 'Input checkbox with parent label').should == 'input-checkbox-with-parent-label-data' }
    it("casts to string")                  { |example| get(example, :'Input checkbox with parent label').should == 'input-checkbox-with-parent-label-data' }
  end

  describe '#radio_button' do
    subject{ :radio_button }
    it("finds radio buttons by id")           { |example| get(example, 'input-radio-with-id').should == 'input-radio-with-id-data' }
    it("finds radio buttons by name")         { |example| get(example, 'input-radio-with-name').should == 'input-radio-with-name-data' }
    it("finds radio buttons by label")        { |example| get(example, 'Input radio with label').should == 'input-radio-with-label-data' }
    it("finds radio buttons by parent label") { |example| get(example, 'Input radio with parent label').should == 'input-radio-with-parent-label-data' }
    it("casts to string")                     { |example| get(example, :'Input radio with parent label').should == 'input-radio-with-parent-label-data' }
  end

  describe '#file_field' do
    subject{ :file_field }
    it("finds file fields by id")           { |example| get(example, 'input-file-with-id').should == 'input-file-with-id-data' }
    it("finds file fields by name")         { |example| get(example, 'input-file-with-name').should == 'input-file-with-name-data' }
    it("finds file fields by label")        { |example| get(example, 'Input file with label').should == 'input-file-with-label-data' }
    it("finds file fields by parent label") { |example| get(example, 'Input file with parent label').should == 'input-file-with-parent-label-data' }
    it("casts to string")                   { |example| get(example, :'Input file with parent label').should == 'input-file-with-parent-label-data' }
  end

  describe "#optgroup" do
    subject { :optgroup }
    it("finds optgroups by label")             { |example| get(example, 'Group A').should == 'optgroup-a' }
    it("finds optgroups by approximate label") { |example| get(example, 'oup A').should == 'optgroup-a' }
    it("casts to string")                      { |example| get(example, :'Group A').should == 'optgroup-a' }

    context "with exact match", :type => :exact do
      it("finds by label")                     { |example| get(example, 'Group A').should == 'optgroup-a' }
      it("does not find by approximate label") { |example| get(example, 'oup A').should be_nil }
    end
  end

  describe '#option' do
    subject{ :option }
    it("finds by text")             { |example| get(example, 'Option with text').should == 'option-with-text-data' }
    it("finds by approximate text") { |example| get(example, 'Option with').should == 'option-with-text-data' }
    it("casts to string")           { |example| get(example, :'Option with text').should == 'option-with-text-data' }

    context "with exact match", :type => :exact do
      it("finds by text")                     { |example| get(example, 'Option with text').should == 'option-with-text-data' }
      it("does not find by approximate text") { |example| get(example, 'Option with').should be_nil }
    end
  end

  describe "#table" do
    subject {:table}
    it("finds by id")                  { |example| get(example, 'table-with-id').should == 'table-with-id-data' }
    it("finds by caption")             { |example| get(example, 'Table with caption').should == 'table-with-caption-data' }
    it("finds by approximate caption") { |example| get(example, 'Table with').should == 'table-with-caption-data' }
    it("casts to string")              { |example| get(example, :'Table with caption').should == 'table-with-caption-data' }

    context "with exact match", :type => :exact do
      it("finds by caption")                     { |example| get(example, 'Table with caption').should == 'table-with-caption-data' }
      it("does not find by approximate caption") { |example| get(example, 'Table with').should be_nil }
    end
  end

  describe "#definition_description" do
    subject {:definition_description}
    let(:template) {'stuff'}
    it("find definition description by id")   { |example| get(example, 'latte').should == "with-id" }
    it("find definition description by term") { |example| get(example, "Milk").should == "with-dt" }
    it("casts to string")                     { |example| get(example, :"Milk").should == "with-dt" }
  end
end
