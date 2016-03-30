require 'test_helper'

class PagesControllerTest < ActionController::TestCase
	test "should return search" do
		get(:search) 
		assert_response :success
	end 
	
	test "should contain list of courses" do
		get(:search, {:semester => "Spring 2016", :subject => "CMPT"})
		assert_select 'tr'
		assert_select 'td', 'CMPT 276'
	end
	
	test "search should link to course sections" do
		get(:search, {:semester => "Spring 2016", :subject => "CMPT"})
		assert_select 'a', 'View Sections'
	end
	
	test "search with course number should have link to course" do
		get(:search, {:semester => "Spring 2016", :subject => "CMPT", :coursenum => "276", :sort => "1"})
		assert_select 'a', 'View'
	end
	
	test "should not have add to past/current course" do
		get(:search, {:semester => "Spring 2016", :subject => "CMPT"})
		assert_select 'div.past_course_button', false 
		assert_select 'div.current_course_button', false
	end
	
	test "should have add to past course" do
		user = User.find_by_username("Cody")
		get(:search, {:semester =>"Spring 2016", :subject => "CMPT"}, session[user] )
		
		assert_response :success
		assert_select 'div.past_course_button'
	end
	
	test "should return course" do
		get(:course, {:semester => "Spring 2016", :subject => "CMPT", :coursenum => "276", :section => "D100"})
		assert_response :success
	end
	
	# test "should return Writing courses" do
	# 	get(:search, {:semester => "Spring 2016", :subject => "CMPT&Writing"})
	# 	assert_select 'td.wqb_specs', 'Writing'
	# 	assert_select 'tr', 3 ##should only have 3 rows
	# end
	
	test "should have professor rating on course page" do
		get(:course, {:semester => "Spring 2016", :subject => "CMPT", :coursenum =>"276", :section => "D100"})
		assert_select 'li.prof_grade', 1 ## Should have only 1 grade because there is one professor
	end
end
