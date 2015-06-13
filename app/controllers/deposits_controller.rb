class DepositsController < ApplicationController
	#unloadable
	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

end