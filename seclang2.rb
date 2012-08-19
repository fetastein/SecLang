require './tiny_prolog.rb'
require './seclang.rb'
#select = pred 'select'
#selects = pred 'selects'
#  select[:X, cons(:X, :XS), :XS] .si
#  select[:X, cons(:Y, :YS), cons(:Y, :ZS)] .si select[:X, :YS, :ZS]
#  selects[cons(:X, :Xs), :Ys] .si select[:X, :Ys, :Ys1], selects[:Xs, :Ys1]  
#  selects[[], :Ys] .si

class SecuriyContext
  attr_accessor :thing, :tags 
  def initialize(name)
    @name = name
    @thing = ''
    @tags = []
  end
  def tags 
    return @tags
  end
end
def seccon(name) return SecuriyContext.new(name) end
  
class Rule
  attr_accessor :subSC, :objSC, :permission
  def initialize(name)
    @name = name
    @subSC = []
    @objSC = []
  end

end
def rule(name) return Rule.new(name) end

def eval_query (query, rules)

#pred 
  set = pred 'set'
  select = pred 'select'
  selects = pred 'selects'
  context = pred 'context'    
  can_access = pred 'can_access'

  #define
  set[:X, :X] .si
puts 'a'
  select[:X, cons(:X, :XS), :XS] .si
  select[:X, cons(:Y, :YS), cons(:Y, :ZS)] .si select[:X, :YS, :ZS]
  
  selects[[], :Ys] .si
  selects[cons(:X, :Xs), :Ys] .si select[:X, :Ys, :Ys1], selects[:Xs, :Ys1]

  rules.each{ |rule|
    # puts rule
    # resolve selects[cons('a', []), ['a', 'b']] do |env|
    #   puts 'seclect'
    # end


    subSC = rule.subSC
    objSC = rule.objSC
    p = rule.permission

    # puts subSC.thing, subSC.tags
    # puts objSC.thing, objSC.tags
    # puts p


    context[rule.subSC.thing, subSC.tags] .si
    context[rule.objSC.thing, objSC.tags] .si
    can_access[:S, :O, :P] .si \
           set[:P,p],
           context[:S, :SubSC],
           context[:O, :ObjSC],
           selects[subSC.tags, :SubSC],
           selects[objSC.tags, :ObjSC] 
  ##test
#     puts '==test'
#     resolve context[rule.subSC.thing, :X] do |env|
#       puts env[:X]
#     end
#     resolve context[rule.objSC.thing, :Y] do |env|
#       puts env[:Y]
#     end
# #    print "list #{list('a')}\n"
#     resolve selects[cons('http', []), ['http', 'conf']] do |env|
#       puts 'seclect!!!'
#     end
#    puts 'test =='
  ##test
  }

  can_access[:S, :O, :P] .si \
          set[:P, 'none']
  print "#{query[0]} and #{query[1]} answer is "
#    print 'permission is '
    resolve can_access['processA','resource1', :P] do |env|
      puts env[:P]
    end
    print "\n"

end

query = ['processA', 'resource1']


context1 = seccon('context1')
context2 = seccon('context2')
context3 = seccon('context3')
context4 = seccon('context4')
rule1 = rule('rule1')
rule2 = rule('rule2')

#Security Context 1
context1.thing = 'resource1'
context1.tags = cons('http', cons('conf', []))

#Security Context 2
context2.thing = 'processA'
context2.tags = cons('http', [])

#Security Context 3
context3.thing = 'processB'
context3.tags = cons('conf', [])

#Security Context 4
context4.thing = 'resource2'
context4.tags = cons('conf', [])

#Rule1
rule1.objSC = context1
rule1.subSC = context2 
rule1.permission = 'read'

#Rule2
rule2.objSC = context3
rule2.subSC = context4
rule2.permission = 'write'

#puts 12
#can_access = pred 'can_access'
#resolve can_access['processA', 'resource1', :A] do |env|
#  puts env[:A] if not(env[:A] == 'none') 
#end
#puts cons('http', [])
#puts '--'
eval_query(query, [rule1, rule2])
