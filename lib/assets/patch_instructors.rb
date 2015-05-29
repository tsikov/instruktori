require File.expand_path('../../../instruktori/config/environment',  __FILE__)

def rename(old_name, new_name)
  ins = Instructor.find_by(name: old_name)
  unless ins.nil?
    ins.name = new_name
    ins.save!
    puts "Instructor #{old_name} renamed -> #{new_name}"
  else
    puts "Already renamed #{old_name} -> #{new_name}"
  end
end

def create(name)
  ins = Instructor.find_by(name: name)

  if ins.nil?
    ins = Instructor.create!({ name: name })
    puts "Instructor #{name} created"
  else
    puts "Already created #{name}"
  end
end

rename "'ВАЛЕНТИ АУТО'' ЕООД", "\"ВАЛЕНТИ АУТО\" ЕООД"
rename "ПРОФЕСИОНАЛНА  АГРОТЕХНИЧЕСКА ГИМНАЗИЯ\"Н. Й. ВАПЦАРОВ\"", "ПРОФЕСИОНАЛНА АГРОТЕХНИЧЕСКА ГИМНАЗИЯ \"Н. Й. ВАПЦАРОВ\""

# Not found in list -> ask the institutions about these
create "\"МЕРИДИАН 888\" ЕООД"
create "ЕТ \"АПИС - МАРИЯ СТОЯНОВА\""
create "\"ВИТА - 6\" АД"
create "ИЗПЪЛНИТЕЛНА АГЕНЦИЯ АВТОМОБИЛНА АДМИНИСТРАЦИЯ"
create "ПРОФЕСИОНАЛНА ГИМНАЗИЯ"     # perhaps known - should ask the gov.
create "\"СТРЕЛЕЦ - 09\" ЕООД"
create "ЕТ \"ПАЛАС - КИРЧО СИМИТЧИЕВ\""
create "ЕТ \"КИРИЛ БЪЧВАРОВ\""
create "ЕТ \"ОЛИМП - 99 - ДИМЧО ИЛИЕВ\""
create "\"ЗЕНИТ - МВ\" ООД"
create "\"ТОМОВ БИЗНЕС ГРУП\" ЕООД"
create "БОРИ ДД"    # perhaps should rename to БОРИ 11???

