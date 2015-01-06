db= require('./gulpfile.config').mysql

'use strict'
describe "Sequelize",->
  # Connection
  Sequelize= require 'sequelize'
  sequelize= new Sequelize db.table_name,db.user,db.password,
    host:db.host
    port:db.port
    define:
      charset:db.charset
      collate:db.collate
      underscored:true # exit UpperCamelCase. like a ruby on rails (not affect table name)
    logging:false # verbose

  # Defines
  User= sequelize.define 'User',
    name:Sequelize.STRING
    birth:Sequelize.DATE

  Project= sequelize.define 'Project',
    description:
      Sequelize.TEXT
    title:
      type:
        Sequelize.STRING
      allowNull:
        false
  #   add Project.delegater_id
  Project.belongsTo User,foreignKey:'delegater_id' 

  Task= sequelize.define 'Task',
    deadline:
      Sequelize.DATE
    description:
      Sequelize.TEXT
    title:
      type:
        Sequelize.STRING
      allowNull:
        false
  #   add Tasks.project_id
  Project.hasMany Task 

  #   create table "ProjectWorkes"
  Project.belongsToMany User,{as:'Worker',through:'ProjectWokers'}
  User.belongsToMany Project,{as:'Worker',through:'ProjectWokers'}

  # Begin test suites
  it 'Sandboxize defines',(done)->
    sequelize
      .query 'set foreign_key_checks=0'
      .success ->
        sequelize.sync
          force:true
        .success ->
          done()
        #   sequelize.query 'set foreign_key_checks=1'
        #     .success done

  it 'Ping-pong',(done)->
    sequelize.query 'select 1',null,raw:true
      .success (results)->
        expect(results[0][1]).toEqual(1)
        done()

  it "Build, Update, and Destroy",(done)->
    user= User.build
      name:'59naga'
      undefined_filed:'ignore!'
    user.save().success (user)->
      expect(user.name).toEqual('59naga')
      expect(user.values.name).toEqual('59naga')
      expect(user.undefined_filed).toBeUndefined()

      user.updateAttributes(birth:'1990-09-18').success (user)->
        expect(user.birth.getMonth()+1).toEqual(9)

        user.birth= user.birth.getTime() + 365 * 60*60*24*1000
        user.save().success (user)->
          expect(user.birth.getFullYear()).toEqual(1991)

          User.count().success (count)->
            expect(count).toEqual(1)

            user.destroy().success (user)->
              expect(user.name).toEqual('59naga')

              User.count().success (count)->
                expect(count).toEqual(0)

                done()

  # it 'Migrate simple schema',(done)->
  #   User.sync().success ->
  #     User.create
  #       name:'ore'
  #       birth:new Date 1990,9,18
  #     .success (user)->
  #       expect(user.id).toEqual(1)
  #       done()


  # describe 'Migrate association',()->
  #   it 'project',(done)->
  #     Project.sync().success ->
  #       project=
  #         title:'とりあえず燃えてる'
  #         description:'これは訓練ではない'
  #       Project.findOrCreate where:project
  #       .success (results)->
  #         project= results[0].dataValues
  #         expect(project.id).toEqual(1)
  #         expect(project.title).toEqual('とりあえず燃えてる')
  #         expect(project.description).toEqual('これは訓練ではない')
  #         done()

  #   it 'tasks',(done)->
  #     Task.sync().success ->
  #       Task.create
  #         project_id:1
  #         title:'火消し'
  #       .success (task)->
  #         expect(task.project_id).toEqual(1)
  #         expect(task.id).toEqual(1)
  #         expect(task.title).toEqual('火消し')
  #         done()
