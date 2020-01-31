class Employee < ActiveRecord::Base
  serialize :avatar, Hash
  belongs_to :employee_template
  belongs_to :department
  belongs_to :employee_contract_type, foreign_key: :contract_type_id
  has_many :experiences, class_name: 'EmployeeWorkExperience', foreign_key: 'employee_id', dependent: :destroy
  has_many :employee_join_competence
  has_many :employee_competence, through: :employee_join_competence
  has_many :diseases, class_name: 'EmployeeDiseases', foreign_key: 'employee_id', dependent: :destroy
  has_many :leaves, class_name: 'EmployeeLeaves', foreign_key: 'employee_id'
  has_many :educationals, class_name: 'EmployeeEducational', foreign_key: 'employee_id', dependent: :destroy
  has_many :diseases, class_name: 'EmployeeDisease', foreign_key: 'employee_id', dependent: :destroy
  has_many :salary_keys, class_name: 'EmployeeSalaryKey', foreign_key: 'employee_id', dependent: :destroy
  has_many :training, class_name: 'EmployeeTraining', foreign_key: 'employee_id', dependent: :destroy

  validates_presence_of :name, :gender, :ni, :department, :employee_template, :race, :employee_contract_type,
                        :job_init_date, message: l(:validates_presence_message)

  validates :name, :comments,
            length: { allow_blank: true, within: 1..255 }
  validates :email, format: { allow_blank: true, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                              multiline: true }

  validates :telephone, format: { allow_blank: true,
                                  with: /^[0-9\s\+\-]+$/i,
                                  multiline: true }
  validates :ni, format: { allow_blank: true,
                           with: /^[0-9]/,
                           multiline: true }

  validates :avatar, format: { with: /\.gif|jpg|png|jpeg|ico/i, allow_blank: true }

  GENDER_MALE = l(:label_gender_male)
  GENDER_FEMALE = l(:label_gender_female)

  def self.employee_gender
    h = {}
    h[Employee::GENDER_MALE] = l(:label_gender_male)
    h[Employee::GENDER_FEMALE] = l(:label_gender_female)
    h
  end

  def image=(image_field)
    avatar[:name] = image_field.original_filename
    avatar[:content_type] = image_field.content_type.chomp
    avatar[:data] = image_field.read
  end

  def self.actives
    where(active: true).count
  end

  def self.inactives
    where(active: false).count
  end

  # Returns a string of css classes that apply to the detail
  def css_classes(user = User.current)
    s = "issue identifier-#{id} employee_template-#{employee_template_id}"
=begin
    if user.logged?
      s << ' created-by-me' if author_id == user.id
    end
=end
    s
  end
end
