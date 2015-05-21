#!/usr/bin/env ferite
uses "../MailUtilities.feh";
uses 'tap.feh';

function translate_entities_test_01(){
	string value = "&#x0043; replaces &#x004C; but not this&123;";
	string regValue = '&#x0*((\d|[a-fA-F])+);*';
	boolean replaced;
	replaced = MailUtilities._translate_entitites(value, regValue, true);

	if(replaced && (value == "C replaces L but not this&123;")){
		pass("translate entities test 01 passed");
	}
	else {
		fail("translate entities test 01 failed");
	}
}

function translate_entities_test_02(){
	string value = "\\\\57 replaces \n but not this\\127";
	string regValue = '\\\\(\d+)';
	boolean replaced;
	replaced = MailUtilities._translate_entitites(value, regValue, true);

	if(replaced && (value == "W replaces \n but not this\\127")){
		pass("translate entities test 02 passed");
	}
	else {
		fail("translate entities test 02 failed");
	}
}

function fix_attribute_value_test_01(){
	string value  = "aaba\xC9\xB4 \xEF\xBD\x95 [&#x029F;]";
	string replaced = MailUtilities._fix_attribute_value(value);
	
	if (replaced == "aaban u [l]"){
		pass("fix attribute test 01 passed");
	}
	else {
		fail("fix attribute test 01 failed");
	}

}

//test into _translate_entitites() as well
function fix_attribute_value_test_02(){
	string value  = "anbu\xC9\xB4 \xEF\xBD\x95 [&#x029F;] &#x0043; \127C";
	string replaced = MailUtilities._fix_attribute_value(value);
	
	if (replaced == "anbun u [l] C WC"){
		pass("fix attribute test 02 passed");
	}
	else {
		fail("fix attribute test 02 failed");
	}

}

function sanitizeHTML_test_01(){
	string value  = "<html>anbu\xC9\xB4 \xEF\xBD\x95 <a href=\"http://www.w3schools.com &#x029F; &#x0043; \\\\0043\"> hello world </> </html>";
	string answer = "anbuɴ ｕ <a href=\"http://www.w3schools.com l C C\" target=\"_blank\"> hello world </> ";
	string randomurl="http://nothing.com/blank.jpg";
	string replaced = MailUtilities._sanitizeHTML(value, randomurl);
	
	if (replaced == answer){
		pass("replaced");
	}
	else {
		fail("replaced failed");
	}

}

//tests starts here
translate_entities_test_01();
translate_entities_test_02();
fix_attribute_value_test_01();
fix_attribute_value_test_02();
sanitizeHTML_test_01();
done_testing();
