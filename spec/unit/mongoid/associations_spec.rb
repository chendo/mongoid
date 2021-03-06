require File.expand_path(File.join(File.dirname(__FILE__), "/../../spec_helper.rb"))

describe Mongoid::Associations do

  before do
    @collection = stub(:name => "people")
    @database = stub(:collection => @collection)
    Mongoid.stubs(:database).returns(@database)
  end

  after do
    Person.instance_variable_set(:@collection, nil)
    @database = nil
    @collection = nil
  end

  describe "#association=" do

    context "when child is a has one" do

      before do
        @person = Person.new(:title => "Sir", :age => 30)
        @name = Name.new(:first_name => "Test", :last_name => "User")
        @person.name = @name
      end

      it "parentizes the association" do
        @name.parent.should == @person
      end

      it "sets the child attributes on the parent" do
        @person.attributes[:name].should ==
          { "_id" => "test-user", "first_name" => "Test", "last_name" => "User" }
      end

    end

    context "when setting a parent" do

      before do
        @person = Person.new(:title => "Mr")
        @address = Address.new(:street => "Picadilly Circus")
        @address.addressable = @person
      end

      it "re-parentizes the association" do
        @address.parent.should == @person
      end

      it "adds the child attributes to the parent" do
        @person.attributes[:addresses].should ==
          [{ "_id" => "picadilly-circus", "street" => "Picadilly Circus" }]
      end

    end

  end

  describe "#belongs_to" do

    it "creates a reader for the association" do
      address = Address.new
      address.should respond_to(:addressable)
    end

    it "creates a writer for the association" do
      address = Address.new
      address.should respond_to(:addressable=)
    end

    it "allows the parent to be any type of class" do
      phone_number = Phone.new(:number => "415-555-1212")
      code = CountryCode.new(:code => 1)
      phone_number.country_code = code
      code.phone_number.should == phone_number
    end

    context "when navigating the graph" do

      before do
        @person = Person.new(:title => "Mr")
        @name = Name.new(:first_name => "Mason")
        @address = Address.new(:street => "King St.")
        @person.name = @name
        @person.addresses << @address
      end

      it "allows referencing another child through the parent" do
        @name.person.addresses.first.should == @address
      end

    end

  end

  describe "#has_many" do

    it "adds a new Association to the collection" do
      person = Person.new
      person.addresses.should_not be_nil
    end

    it "creates a reader for the association" do
      person = Person.new
      person.should respond_to(:addresses)
    end

    it "creates a writer for the association" do
      person = Person.new
      person.should respond_to(:addresses=)
    end

    context "when setting the association directly" do

      before do
        @attributes = { :title => "Sir",
          :addresses => [
            { :street => "Street 1" },
            { :street => "Street 2" } ] }
        @person = Person.new(@attributes)
      end

      it "sets the attributes for the association" do
        address = Address.new(:street => "New Street")
        @person.addresses = [address]
        @person.addresses.first.street.should == "New Street"
      end

    end

    context "when a class_name is supplied" do

      before do
        @attributes = { :title => "Sir",
          :phone_numbers => [ { :number => "404-555-1212" } ]
        }
        @person = Person.new(@attributes)
      end

      it "sets the association name" do
        @person.phone_numbers.first.should == Phone.new(:number => "404-555-1212")
      end

    end

    context "when updating objects internally" do

      before do
        @address = Address.new(:street => "Bourke Street")
        @person = Person.new(:title => "Sir")
        @person.addresses << @address
        @person.update_addresses
      end

      it "retains its references to the original objects" do
        @address.street.should == "Updated 0"
      end

    end

  end

  describe "#has_one" do

    it "adds a new Association to the collection" do
      person = Person.new
      person.name.should_not be_nil
    end

    it "creates a reader for the association" do
      person = Person.new
      person.should respond_to(:name)
    end

    it "creates a writer for the association" do
      person = Person.new
      person.should respond_to(:name=)
    end

    context "when setting the association directly" do

      before do
        @attributes = { :title => "Sir",
          :name => { :first_name => "Test" } }
        @person = Person.new(@attributes)
      end

      it "sets the attributes for the association" do
        name = Name.new(:first_name => "New Name")
        @person.name = name
        @person.name.first_name.should == "New Name"
      end

    end

    context "when a class_name is supplied" do

      before do
        @attributes = { :title => "Sir",
          :pet => { :name => "Fido" }
        }
        @person = Person.new(@attributes)
      end

      it "sets the association name" do
        @person.pet.should == Animal.new(:name => "Fido")
      end

    end

  end

end
