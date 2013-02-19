class Search < ActiveRecord::Base



  def self.get_last
      find(:all, :order => "id desc", :limit => 1).reverse
  end

  def self.search(search)
    find(:all, :conditions => ['"searches".text = '<< '"' << search.to_s << '"', "%#{search}%"])

  end


end
