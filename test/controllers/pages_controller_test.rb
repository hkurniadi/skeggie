require 'test_helper'

class PagesControllerTest < ActionController::TestCase
	
	test "should return search" do
		get(:search) 
		assert_response :success
	end 
	
	test "should return no results" do
		get(:search, {:semester => "Spring 2016", :subject => "acma"})
		assert_response :success
		assert_select 'p#no_results'
	end
	
	test "nav bar should be different depending on log in status" do
		get(:index)
		assert_response :success
		assert_select 'li', 6 ## 6 List items in nav bar
		assert_select 'a', 'Login'
		
		cody = users(:cody)
		get(:index, nil, {'user_id' => cody.id})
		assert_response :success
		assert_select 'li', 10 ## 4 new list items in nav bar
		assert_select 'a', 'Log out'
		assert_select 'a', 'Profile'
		assert_select 'a', 'My Schedule'
	end
	
	test "should contain list of courses" do
		get(:search, {:semester => "Spring 2016", :subject => "cmpt"})
		assert_select 'tr'
		assert_select 'td.dep_cid', 'CMPT 276'
	end
	
	test "search should link to course sections" do
		get(:search, {:semester => "Spring 2016", :subject => "cmpt"})
		assert_select 'a', 'View Sections'
	end
	
	test "search with course number should have link to course" do
		get(:search, {:semester => "Spring 2016", :subject => "cmpt", :coursenum => "276", :sort => "1"})
		assert_select 'a', 'View'
	end
	
	test "should not have add to past/current course" do
		get(:search, {:semester => "Spring 2016", :subject => "cmpt"})
		assert_select 'div.past_course_button', false 
		assert_select 'div.current_course_button', false
	end
	
	test "should have add to past course" do
		cody = users(:cody)
		get(:search, {:semester =>"Spring 2016", :subject => "cmpt"}, {'user_id' => cody.id} )
		assert_response :success
		assert_select 'div.past_course_button'
	end
	
	test "past course button should change" do
		cody = users(:cody)
		get(:search, {:semester => "Spring 2016", :subject => "cmpt", :coursenum => "276",
						:sort => "1"}, {'user_id' => cody.id})
		assert_select "form input[type=submit][name=commit][value='Add to Past Courses']"
		cody.past_courses.push("cmpt 276")
		cody.save
		get(:search, {:semester => "Spring 2016", :subject => "cmpt", :coursenum => "276",
						:sort => "1"}, {'user_id' => cody.id})
		
		assert_select "form input[type=submit][name=commit][value='Remove from Past Courses']"
	end
	
	test "should have two add to cart buttons" do
		cody = users(:cody)
		get(:search, {:semester => "Spring 2016", :subject => "cmpt", :coursenum => "276", 
						:sort => "1"}, {'user_id' => cody.id})
		assert_select "form input[type=submit][name=commit][value='Add to Cart']", 2
	end
	
	test "should have remove from cart button" do
		cody = users(:cody)
		cody.current_courses.push('2016 Spring cmpt 276 D100 LEC')
		cody.save
		get(:search, {:semester => "Spring 2016", :subject => "cmpt", :coursenum => "276", 
						:sort => "1"}, {'user_id' => cody.id})
		assert_select "form input[type=submit][name=commit][value='Remove from Cart']", 1
	end
	
	test "should not have add to cart button since not current semester" do
		cody = users(:cody)
		get(:search, {:semester => "Fall 2015", :subject => "cmpt", :coursenum => "276",
						:sort => "1"}, {'user_id' => cody.id})
		assert_select "form input[type=submit][name=commit][value='Add to Cart']", 0
	end
	
	test "should offer to replace course in cart" do
		cody = users(:cody)
		cody.current_courses.push('2016 Spring cmpt 276 D100 LEC')
		cody.save!
		get(:search, {:semester => "Spring 2016", :subject => "cmpt", :coursenum => "361", 
						:sort => "1"}, {'user_id' => cody.id})
		assert_select "form input[type=submit][name=commit][value='Replace with CMPT 361 D100']", 1
	end
	
	test "should return course" do
		get(:course, {:semester => "Spring 2016", :subject => "cmpt", :coursenum => "276", :section => "D100"})
		assert_response :success
	end
	
	test "should return Writing courses" do
		get(:search, {:semester => "Spring 2016", :subject => "cmpt", :wqb => "Writing"})
		assert_select 'td.wqb_specs', 'Writing'
		assert_select 'tr', 3 ##should only have 3 rows
 	end
	
	test "should have professor rating on search page" do
		cody = users(:cody)
		get(:search, {:semester => "Spring 2016", :subject => "cmpt", :coursenum => "276", 
					:sort => "1"}, {'user_id' => cody.id})
		assert_select 'td.prof_grade', 2 ## Two lecture sections
	end
	
	test "sections that aren't lectures do not have professor rating" do
		cody = users(:cody)
		get(:search, {:semester => "Spring 2016", :subject => "cmpt", :coursenum => "120", 
					:sort => "1"}, {'user_id' => cody.id})
		assert_select 'td.course_section', 7 ## 1 Lecture section and 6 Lab sections
		assert_select 'td.prof_grade', 1
	end
	
	test "should have professor rating on course page" do
		get(:course, {:semester => "Spring 2016", :subject => "CMPT", :coursenum =>"276", :section => "D100"})
		assert_select 'li.prof_grade', 1 ## Should have only 1 grade because there is one professor
	end
	
	test "should return general course page" do 
		get(:course, {:subject => "cmpt", :coursenum => "276"})
		assert_response :success
	end
	
	test "general course page has links to only semesters that are available" do
		get(:course, {:subject => "cmpt", :coursenum => "276"})
		assert_response :success
		assert_select 'a', {count: 1, text: 'Fall 2015'}
		assert_select 'a', {count: 1, text: 'Spring 2016'}
		assert_select 'a', {count: 0, text: 'Summer 2016'} ## Actually is in this semester, just not for this test
	end
	
	test "should return catalogue page" do
		get(:catalogue, {:sub_l => "c"})
		assert_response :success
		assert_select 'a', 37 ## 6 in nav bar
		assert_select 'li', 10 ## 5 in nav bar
	end
end
