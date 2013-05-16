require "spec_helper"

describe MetricFu::LineNumbers do

  describe "in_method?" do
    it "should know if a line is NOT in a method" do
      ln = MetricFu::LineNumbers.new(File.read("#{resources_path}/line_numbers/foo.rb"))
      ln.in_method?(2).should == false
    end

    it "should know if a line is in an instance method" do
      ln = MetricFu::LineNumbers.new(File.read("#{resources_path}/line_numbers/foo.rb"))
      ln.in_method?(8).should == true
    end

    it "should know if a line is in an class method" do
      ln = MetricFu::LineNumbers.new(File.read("#{resources_path}/line_numbers/foo.rb"))
      ln.in_method?(3).should == true
    end
  end

  describe "method_at_line" do
    it "should know the name of an instance method at a particular line" do
      ln = MetricFu::LineNumbers.new(File.read("#{resources_path}/line_numbers/foo.rb"))
      ln.method_at_line(8).should == "Foo#what"
    end

    it "should know the name of a class method at a particular line" do
      ln = MetricFu::LineNumbers.new(File.read("#{resources_path}/line_numbers/foo.rb"))
      ln.method_at_line(3).should == "Foo::awesome"
    end

    it "should know the name of a private method at a particular line" do
      ln = MetricFu::LineNumbers.new(File.read("#{resources_path}/line_numbers/foo.rb"))
      ln.method_at_line(28).should == "Foo#whoop"
    end

    it "should know the name of a class method defined in a 'class << self block at a particular line" do
      ln = MetricFu::LineNumbers.new(File.read("#{resources_path}/line_numbers/foo.rb"))
      ln.method_at_line(22).should == "Foo::neat"
    end

    it "should know the name of an instance method at a particular line in a file with two classes" do
      ln = MetricFu::LineNumbers.new(File.read("#{resources_path}/line_numbers/two_classes.rb"))
      ln.method_at_line(3).should == "Foo#stuff"
      ln.method_at_line(9).should == "Bar#stuff"
    end

    it "should work with modules" do
      ln = MetricFu::LineNumbers.new(File.read("#{resources_path}/line_numbers/module.rb"))
      ln.method_at_line(4).should == 'KickAss#get_beat_up?'
    end

    it "should work with module surrounding class" do
      ln = MetricFu::LineNumbers.new(File.read("#{resources_path}/line_numbers/module_surrounds_class.rb"))
      ln.method_at_line(5).should == "StuffModule::ThingClass#do_it"
      # ln.method_at_line(12).should == "StuffModule#blah" #why no work?
    end

  end
  # s(:iter, s(:call, s(:const, :ActiveAdmin), :register, s(:const, :User)), s(:args), s(:block, s(:iter, s(:call, nil, :index), s(:args), s(:block, s(:call, nil, :column, s(:lit, :email)), s(:call, nil, :column, s(:lit, :current_sign_in_at)), s(:call, nil, :column, s(:lit, :last_sign_in_at)), s(:call, nil, :column, s(:lit, :sign_in_count)), s(:call, nil, :default_actions))), s(:call, nil, :filter, s(:lit, :email)), s(:iter, s(:call, nil, :form), s(:args, :f), s(:block, s(:iter, s(:call, s(:lvar, :f), :inputs, s(:str, "Admin Details")), s(:args), s(:block, s(:call, s(:lvar, :f), :input, s(:lit, :email)), s(:call, s(:lvar, :f), :input, s(:lit, :password)), s(:call, s(:lvar, :f), :input, s(:lit, :password_confirmation)))), s(:call, s(:lvar, :f), :actions)))))
  # "ActiveAdmin.register User do\n  index do\n    column :email\n    column :current_sign_in_at\n    column :last_sign_in_at\n    column :sign_in_count\n    default_actions\n  end\n  filter :email\n  form do |f|\n    f.inputs \"Admin Details\" do\n      f.input :email\n      f.input :password\n      f.input :password_confirmation\n    end\n    f.actions\n  end\nend\n"

  # s(:iter, s(:call, s(:const, :ActiveAdmin), :register_page, s(:str, "Titles")), s(:args), s(:call, nil, :menu, s(:false)))
  # "   "ActiveAdmin.register_page \"Titles\" do\n  menu false\nend\n"

  # s(:iter, s(:call, s(:call, nil, :context), :instance_eval), s(:args), s(:block, s(:call, nil, :column, s(:lit, :title)), s(:iter, s(:call, nil, :column, s(:str, "Star Rating"), s(:str, "titles.star_rating"), s(:hash, s(:lit, :sortable), s(:str, "titles.star_rating"))), s(:args, :title), s(:call, nil, :star_rating, s(:call, s(:lvar, :title), :star_rating))), s(:call, nil, :column, s(:lit, :network_names)), s(:call, nil, :column, s(:lit, :created_at))))
  #     "context.instance_eval do\n  column :title\n  column \"Star Rating\", 'titles.star_rating', :sortable => 'titles.star_rating' do |title|\n    star_rating(title.star_rating)\n  end\n  column :network_names\n  column :created_at\nend\n"



  #  s(:iter, s(:call, s(:call, nil, :context), :instance_eval), s(:args), s(:iter, s(:call, nil, :attributes_table), s(:args), s(:block, s(:call, nil, :row, s(:lit, :id)), s(:call, nil, :row, s(:lit, :title)), s(:call, nil, :row, s(:lit, :sortable_title)), s(:iter, s(:call, nil, :row, s(:lit, :title_akas)), s(:args), s(:block, s(:call, nil, :tr), s(:iter, s(:call, s(:call, s(:call, nil, :title), :title_akas), :each), s(:args, :title_aka), s(:block, s(:call, nil, :tr), s(:call, nil, :td), s(:call, nil, :td, s(:call, s(:lvar, :title_aka), :aka)))))), s(:iter, s(:call, nil, :row, s(:lit, :star_rating)), s(:args, :title), s(:call, nil, :star_rating, s(:call, s(:lvar, :title), :star_rating))), s(:iter, s(:call, nil, :row, s(:lit, :networks)), s(:args), s(:block, s(:call, nil, :tr), s(:call, nil, :td), s(:call, nil, :td, s(:str, "name")), s(:iter, s(:call, s(:call, s(:call, nil, :title), :networks), :each), s(:args, :network), s(:block, s(:call, nil, :tr), s(:call, nil, :td), s(:call, nil, :td, s(:call, s(:lvar, :network), :name)))))), s(:call, nil, :row, s(:lit, :start_date)), s(:call, nil, :row, s(:lit, :end_date)), s(:iter, s(:call, nil, :row, s(:lit, :title_releases)), s(:args), s(:block, s(:call, nil, :tr), s(:call, nil, :td), s(:call, nil, :td, s(:str, "description")), s(:call, nil, :td, s(:str, "release_type")), s(:call, nil, :td, s(:str, "year")), s(:call, nil, :td, s(:str, "month")), s(:call, nil, :td, s(:str, "day")), s(:iter, s(:call, s(:call, s(:call, nil, :title), :title_releases), :each), s(:args, :title_release), s(:block, s(:call, nil, :tr), s(:call, nil, :td), s(:call, nil, :td, s(:call, s(:lvar, :title_release), :description)), s(:call, nil, :td, s(:call, s(:lvar, :title_release), :release_type)), s(:call, nil, :td, s(:call, s(:lvar, :title_release), :year)), s(:call, nil, :td, s(:call, s(:lvar, :title_release), :month)), s(:call, nil, :td, s(:call, s(:lvar, :title_release), :day)))))), s(:call, nil, :row, s(:lit, :members_only)), s(:iter, s(:call, nil, :row, s(:lit, :countries)), s(:args), s(:block, s(:call, nil, :tr), s(:call, nil, :td), s(:call, nil, :td, s(:str, "name")), s(:call, nil, :td, s(:str, "code")), s(:iter, s(:call, s(:call, s(:call, nil, :title), :countries), :each), s(:args, :country), s(:block, s(:call, nil, :tr), s(:call, nil, :td), s(:call, nil, :td, s(:call, s(:lvar, :country), :name)), s(:call, nil, :td, s(:call, s(:lvar, :country), :code)))))), s(:call, nil, :row, s(:lit, :imdb_id)), s(:call, nil, :row, s(:lit, :library_id)), s(:call, nil, :row, s(:lit, :internal_notes)), s(:call, nil, :row, s(:lit, :updated_at)), s(:call, nil, :row, s(:lit, :created_at)))))
  # "   "context.instance_eval do\n  attributes_table do\n    row :id\n    row :title\n    row :sortable_title\n    row :title_akas do\n      tr\n      title.title_akas.each do |title_aka|\n        tr\n          td\n          td title_aka.aka\n      end\n    end\n    row :star_rating do |title|\n      star_rating(title.star_rating)\n    end\n    row :networks do\n      tr\n        td\n        td 'name'\n        title.networks.each do |network|\n          tr\n            td\n            td network.name\n        end\n    end\n    row :start_date\n    row :end_date\n    row :title_releases do\n      tr\n        td\n        td 'description'\n        td 'release_type'\n        td 'year'\n        td 'month'\n        td 'day'\n        title.title_releases.each do |title_release|\n          tr\n            td\n            td title_release.description\n            td title_release.release_type\n            td title_release.year\n            td title_release.month\n            td title_release.day\n        end\n    end\n    row :members_only\n    row :countries do\n      tr\n        td\n        td 'name'\n        td 'code'\n        title.countries.each do |country|\n          tr\n            td\n            td country.name\n            td country.code\n        end\n    end\n    row :imdb_id\n    row :library_id\n    row :internal_notes\n    row :updated_at\n    row :created_at\n  end\nend\n"



  # s(:cdecl, :DateRange, s(:iter, s(:call, s(:const, :Struct), :new, s(:lit, :start_date), s(:lit, :end_date)), s(:args), s(:defn, :valid?, s(:args), s(:if, s(:and, s(:call, s(:call, s(:call, nil, :start_date), :to_s), :!=, s(:str, "")), s(:call, s(:call, s(:call, nil, :end_date), :to_s), :!=, s(:str, ""))), s(:call, s(:call, nil, :start_date), :<=, s(:call, nil, :end_date)), s(:true)))))
  #  DateRange = Struct.new(:start_date, :end_date) do\n  def valid?\n    if start_date.to_s != '' && end_date.to_s != ''\n      start_date <= end_date\n    else\n      true\n    end\n  end\n\nend\n"
end
