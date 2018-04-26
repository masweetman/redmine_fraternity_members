class FraternityMembersController < ApplicationController
  #unloadable

  before_filter :authorize_global, :only => [:export, :export_google_contacts, :export_crm, :crm, :edit, :update]

  helper :sort
  include SortHelper
  helper :custom_fields
  include CustomFieldsHelper

  def query
    query = []
    if params[:chapter].present?
      query << "chapter LIKE '#{params[:chapter]}%'"
    end
    if params[:search].present?
      search = params[:search].split
      query << search.map{ |word| "(active_number LIKE '#{word}' OR firstname LIKE '#{word}%' OR lastname LIKE '#{word}%' OR pledge_name LIKE '%#{word}%' OR mail LIKE '#{word}%')" }.join(" AND ")
    end
    if params[:status].present?
      active = 1 if params[:status] == 'Actives'
      active = 0 if params[:status] == 'Alumni'
      query << "active = '#{active}'" unless active.nil?
    end
    return query.join(' AND ')
  end

  def index
    sort_init [['id', 'desc'], ['chapter', 'asc'], ['active_number', 'asc']]
    sort_update %w(id chapter active_number lastname pledge_name mail phone address graduation_year)

    scope = FraternityMember.where(query)

    if params[:zip].present? && params[:dist].present?
      scope = scope.near(params[:zip].to_s, params[:dist].to_i)
    end

    @member_count = scope.count(:all)
    @member_pages = Paginator.new @member_count, 100, params['page']
    @offset ||= @member_pages.offset
    @members = scope.offset(@offset).limit(100).order(sort_clause).all
  end

  def crm
    sort_init [['chapter', 'asc'], ['active_number', 'asc']]
    sort_update %w(chapter active_number lastname pledge_name mail phone address graduation_year)

    scope = FraternityMember

    if params[:zip].present? && params[:dist].present?
      scope = scope.near(params[:zip].to_s, params[:dist].to_i)
    end

    if params[:chapter].present? || params[:search].present?
      scope = scope.where(query)
    end

    if params[:status].present?
      if params[:status] == 'Actives'
        scope = scope.where(:active => true)
      end
      if params[:status] == 'Alumni'
        scope = scope.where(:active => false)
      end
    end

    @member_count = scope.count(:all)
    @member_pages = Paginator.new @member_count, 100, params['page']
    @offset ||= @member_pages.offset
    @members = scope.offset(@offset).limit(100).order(sort_clause).all
  end

  def new
    @fraternity_member = FraternityMember.new
    session[:return_to] = request.referer
  end

  def create
    @fraternity_member = FraternityMember.new

    @fraternity_member.firstname = params[:fraternity_member][:firstname]
    @fraternity_member.middlename = params[:fraternity_member][:middlename]
    @fraternity_member.lastname = params[:fraternity_member][:lastname]
    @fraternity_member.mail = params[:fraternity_member][:mail]
    @fraternity_member.chapter = params[:fraternity_member][:chapter]
    @fraternity_member.active_number = params[:fraternity_member][:active_number]
    @fraternity_member.pledge_name = params[:fraternity_member][:pledge_name]
    @fraternity_member.big_bro = params[:fraternity_member][:big_bro]
    @fraternity_member.phone = params[:fraternity_member][:phone]
    @fraternity_member.address = params[:fraternity_member][:address]
    @fraternity_member.graduation_year = params[:fraternity_member][:graduation_year]
    @fraternity_member.bio = params[:fraternity_member][:bio]
    @fraternity_member.facebook = params[:fraternity_member][:facebook]
    @fraternity_member.linkedin = params[:fraternity_member][:linkedin]
    @fraternity_member.name_suffix = params[:fraternity_member][:name_suffix]
    @fraternity_member.pledge_class = params[:fraternity_member][:pledge_class]
    @fraternity_member.little_bros = params[:fraternity_member][:little_bros]
    @fraternity_member.job_title = params[:fraternity_member][:job_title]
    @fraternity_member.employer = params[:fraternity_member][:employer]
    @fraternity_member.giving_history = params[:fraternity_member][:giving_history]
    @fraternity_member.alumni_involvement = params[:fraternity_member][:alumni_involvement]
    @fraternity_member.email_interaction = params[:fraternity_member][:email_interaction]
    @fraternity_member.notes = params[:fraternity_member][:notes]

    if @fraternity_member.save
      redirect_to session.delete(:return_to)
      flash[:notice] = l(:notice_successful_update)
    else
      render :action => 'edit'
    end
  end

  def edit
    @fraternity_member = FraternityMember.find(params[:id])
    session[:return_to] = request.referer
  end

  def update
    @fraternity_member = FraternityMember.find(params[:id])

    @fraternity_member.firstname = params[:fraternity_member][:firstname]
    @fraternity_member.middlename = params[:fraternity_member][:middlename]
    @fraternity_member.lastname = params[:fraternity_member][:lastname]
    @fraternity_member.mail = params[:fraternity_member][:mail]
    @fraternity_member.chapter = params[:fraternity_member][:chapter]
    @fraternity_member.active_number = params[:fraternity_member][:active_number]
    @fraternity_member.pledge_name = params[:fraternity_member][:pledge_name]
    @fraternity_member.big_bro = params[:fraternity_member][:big_bro]
    @fraternity_member.phone = params[:fraternity_member][:phone]
    @fraternity_member.address = params[:fraternity_member][:address]
    @fraternity_member.graduation_year = params[:fraternity_member][:graduation_year]
    @fraternity_member.bio = params[:fraternity_member][:bio]
    @fraternity_member.facebook = params[:fraternity_member][:facebook]
    @fraternity_member.linkedin = params[:fraternity_member][:linkedin]
    @fraternity_member.name_suffix = params[:fraternity_member][:name_suffix]
    @fraternity_member.pledge_class = params[:fraternity_member][:pledge_class]
    @fraternity_member.little_bros = params[:fraternity_member][:little_bros]
    @fraternity_member.job_title = params[:fraternity_member][:job_title]
    @fraternity_member.employer = params[:fraternity_member][:employer]
    @fraternity_member.giving_history = params[:fraternity_member][:giving_history]
    @fraternity_member.alumni_involvement = params[:fraternity_member][:alumni_involvement]
    @fraternity_member.email_interaction = params[:fraternity_member][:email_interaction]
    @fraternity_member.notes = params[:fraternity_member][:notes]

    if @fraternity_member.save
      redirect_to session.delete(:return_to)
      flash[:notice] = l(:notice_successful_update)
    else
      render :action => 'edit'
    end
  end

  def export
    scope = FraternityMember

    if params[:chapter].present? or params[:search].present?
      scope = scope.where(query)
    else
      scope = scope.all
    end

    @fraternity_members = scope.sort_by{|a| [a.chapter, a.active_number]}

    export_csv = 'Chapter,Active No,First Name,Middle Name,Last Name,Pledge Name,E-mail Address,Home Phone,Home Address,Graduation Year,Current Active?' + "\n"
    @fraternity_members.each do |e|
      

      export_csv << '"'+e.chapter.to_s.gsub(',','')+'"'+','+
                    '"'+e.active_number.to_s.gsub(',','')+'"'+','+
                    '"'+e.firstname.to_s.gsub(',','')+'"'+','+
                    '"'+e.middlename.to_s.gsub(',','')+'"'+','+
                    '"'+e.lastname.to_s.gsub(',','')+'"'+','+
                    '"'+e.pledge_name.to_s.gsub(',','')+'"'+','+
                    '"'+e.mail.to_s.gsub(',','')+'"'+','+
                    '"'+e.phone.to_s.gsub(',','')+'"'+','+
                    '"'+e.address.to_s.gsub(',','')+'"'+','+
                    '"'+e.graduation_year.to_s+'"'+','+
                    '"'+e.active.to_s+'"'+"\n"
    end
    
    send_data(export_csv,
      :type => 'text/csv; charset=utf-8; header=present',
      :filename => "export.csv")
  end

  def export_google_contacts
    scope = FraternityMember

    if params[:chapter].present? or params[:search].present?
      scope = scope.where(query)
    else
      scope = scope.all
    end

    @fraternity_members = scope.sort_by{|a| [a.chapter, a.active_number]}

    fallback = { 
      'Š'=>'S', 'š'=>'s', 'Ð'=>'Dj','Ž'=>'Z', 'ž'=>'z', 'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A',
      'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E', 'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I',
      'Ï'=>'I', 'Ñ'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O', 'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U', 'Ú'=>'U',
      'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss','à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a',
      'å'=>'a', 'æ'=>'a', 'ç'=>'c', 'è'=>'e', 'é'=>'e', 'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i',
      'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ò'=>'o', 'ó'=>'o', 'ô'=>'o', 'õ'=>'o', 'ö'=>'o', 'ø'=>'o', 'ù'=>'u',
      'ú'=>'u', 'û'=>'u', 'ý'=>'y', 'þ'=>'b', 'ÿ'=>'y', 'ƒ'=>'f'
      }

    export_csv = 'Chapter,Active No,Name,E-mail Address,Home Phone,Home Address,Graduation Year,Current Active?' + "\n"
    @fraternity_members.each do |e|

      if e.mail.to_s != ""
        if e.pledge_name.to_s == ""
          full_name = e.firstname.to_s+' '+e.lastname.to_s
        else
          full_name = e.firstname.to_s+' '+e.lastname.to_s+' ('+e.pledge_name.to_s.truncate(18)+')'
        end

        export_csv << '"'+e.chapter.to_s.gsub(',','')+'"'+','+
                      '"'+e.active_number.to_s.gsub(',','')+'"'+','+
                      '"'+full_name.squish.gsub(',','')+'"'+','+
                      '"'+e.mail.to_s.gsub(',','')+'"'+','+
                      '"'+e.phone.to_s.gsub(',','')+'"'+','+
                      '"'+e.address.to_s.gsub(',','')+'"'+','+
                      '"'+e.graduation_year.to_s+'"'+','+
                      '"'+e.active.to_s+'"'+"\n"
      end
    end
    
    send_data(export_csv.encode('us-ascii',:fallback => fallback),
      :type => 'text/csv; charset=utf-8; header=present',
      :filename => "google_contacts.csv")
  end

  def export_crm
    flash[:notice] = 'Database export is currently under development.'
  end

  def join_group
    m = Member.new(:user => User.find(params[:user]), :roles => [Role.find(params[:role_id])])
    project = Project.find(params[:project])
    project.members << m
	
    redirect_to controller: 'projects', action: 'show', id: project
  end
  
  private

  def fraternity_member_params
    params.require(:fraternity_member).permit(:chapter)
  end

end
