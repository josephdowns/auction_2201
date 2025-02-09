require './lib/item'
require './lib/attendee'
require './lib/auction'
require 'rspec'
require 'pry'
require 'date'

describe Auction do
  context "the beginning" do
    before (:each) do
      @item1 = Item.new("Chalkware Piggy Bank")
      @item2 = Item.new("Bamboo Picture Frame")
      @attendee = Attendee.new({name: "Megan", budget: "$50"})
      @auction = Auction.new
    end

    it "is classy" do
      expect(@auction).to be_a(Auction)
      expect(@auction.items).to eq([])
    end

    it "can have items" do
      @auction.add_item(@item1)
      @auction.add_item(@item2)

      expect(@auction.items).to eq([@item1, @item2])
      expect(@auction.item_names).to eq(["Chalkware Piggy Bank", "Bamboo Picture Frame"])
    end
  end

  context "the middle" do
    before (:each) do
      @item1 = Item.new("Chalkware Piggy Bank")
      @item2 = Item.new("Bamboo Picture Frame")
      @item3 = Item.new("Homemade Chocolate Chip Cookies")
      @item4 = Item.new("2 Days Dogsitting")
      @item5 = Item.new ("Forever Stamps")
      @attendee1 = Attendee.new({name: "Megan", budget: "$50"})
      @attendee2 = Attendee.new({name: "Bob", budget: "$75"})
      @attendee3 = Attendee.new({name: "Mike", budget: "$100"})
      @auction = Auction.new
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      @auction.add_item(@item3)
      @auction.add_item(@item4)
      @auction.add_item(@item5)
    end

    it "has bids" do
      expect(@item1.bids).to eq({})
    end

    it "gets bids" do
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      expect(@item1.bids).to eq({
          @attendee2 => 20,
          @attendee1 => 22
          })
    end

    it "looks at bids" do
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      expect(@item1.current_high_bid).to eq(22)
    end

    it "can find the unloved items" do
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      @item4.add_bid(@attendee3, 50)
        expect(@auction.unpopular_items).to eq([@item2, @item3, @item5])
        @item3.add_bid(@attendee2, 15)
        expect(@auction.unpopular_items).to eq([@item2, @item5])
    end

    it "finds potential revenue" do
        @item1.add_bid(@attendee2, 20)
        @item1.add_bid(@attendee1, 22)
        @item4.add_bid(@attendee3, 50)
        @item3.add_bid(@attendee2, 15)
        expect(@auction.potential_revenue).to eq(87)
    end
  end

  context "the end" do
    before (:each) do
      @item1 = Item.new("Chalkware Piggy Bank")
      @item2 = Item.new("Bamboo Picture Frame")
      @item3 = Item.new("Homemade Chocolate Chip Cookies")
      @item4 = Item.new("2 Days Dogsitting")
      @item5 = Item.new ("Forever Stamps")
      @attendee1 = Attendee.new({name: "Megan", budget: "$50"})
      @attendee2 = Attendee.new({name: "Bob", budget: "$75"})
      @attendee3 = Attendee.new({name: "Mike", budget: "$100"})
      @auction = Auction.new
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      @auction.add_item(@item3)
      @auction.add_item(@item4)
      @auction.add_item(@item5)
      @item1.add_bid(@attendee1, 22)
      @item1.add_bid(@attendee2, 20)
      @item4.add_bid(@attendee3, 50)
      @item3.add_bid(@attendee2, 15)
    end

    it "can list bidders" do
      expect(@auction.bidders).to eq(["Megan", "Bob", "Mike"])
    end

    it "can close bidding" do
      @item1.close_bidding
      @item1.add_bid(@attendee3, 70)
      expect(@item1.bids).to eq({
          @attendee2 => 20,
          @attendee1 => 22
          })
    end

    it "creates a big bad bidder hash" do
      expect(@auction.bidder_info).to eq(
        {
          @attendee1 =>
            {
              :budget => 50,
              :items => [@item1]
            },

          @attendee2 =>
            {
              :budget => 75,
              :items => [@item1, @item3]
            },
          @attendee3 =>
            {
              :budget => 100,
              :items => [@item4]
            }
          })
    end
  end

  context "the epilogue" do
    before (:each) do
      @item1 = Item.new("Chalkware Piggy Bank")
      @item2 = Item.new("Bamboo Picture Frame")
      @item3 = Item.new("Homemade Chocolate Chip Cookies")
      @item4 = Item.new("2 Days Dogsitting")
      @item5 = Item.new ("Forever Stamps")
      @attendee1 = Attendee.new({name: "Megan", budget: "$50"})
      @attendee2 = Attendee.new({name: "Bob", budget: "$75"})
      @attendee3 = Attendee.new({name: "Mike", budget: "$100"})
      @auction = Auction.new
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      @auction.add_item(@item3)
      @auction.add_item(@item4)
      @auction.add_item(@item5)
      @item1.add_bid(@attendee1, 22)
      @item1.add_bid(@attendee2, 20)
      @item4.add_bid(@attendee2, 30)
      @item4.add_bid(@attendee3, 50)
      @item3.add_bid(@attendee2, 15)
      @item5.add_bid(@attendee1, 35)
    end

    it "returns the date" do
      expect(@auction.date).to eq("08/03/2022")
    end
  end
end
