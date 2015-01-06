# [Sequelize](http://sequelizejs.com/) is awesome
## Usage example version 2.0.0-rc6
```bash
$
  git clone https://github.com/59naga/sequelize-cheatsheet.git 4sequelizer && cd 4sequelizer
  npm install
  npm test
```
please, Change the __gulpfile.config.coffee__ to your development.

## [Connection][1]
```coffee-script
db= require('./gulpfile.config').mysql

Sequelize= require 'sequelize'
sequelize= new Sequelize db.table_name,db.user,db.password,
  host:db.host
  port:db.port
  define:
    charset:db.charset
    collate:db.collate
  logging:false

#ping-pong
sequelize.query 'select 1',null,raw:true
  .success (results)->
    console.log results # > [ { '1': 1 } ]
```
## [Model define][2]
```coffee-script
Project= sequelize.define 'Project',
  description:Sequelize.TEXT
  title:
    type:Sequelize.STRING
    allowNull:false

Project.sync().success ->
  Project.create
    title:'とりあえず燃えてる'
    description:'これは訓練ではない'
  .success (project)->
    console.log project # > { id: 1,title: 'とりあえず燃えてる', description: 'これは訓練ではない', updated_at: ..., created_at: ... }
```
## [Column types][3]
```coffee-script
Sequelize.STRING                   # VARCHAR(255)
Sequelize.STRING 1234              # VARCHAR(1234)
Sequelize.STRING.BINARY            # VARCHAR BINARY
Sequelize.TEXT                     # TEXT
 
Sequelize.INTEGER                  # INTEGER
Sequelize.BIGINT                   # BIGINT
Sequelize.BIGINT 11                # BIGINT(11)
Sequelize.FLOAT                    # FLOAT
Sequelize.FLOAT 11                 # FLOAT(11)
Sequelize.FLOAT 11,12              # FLOAT(11,12)
 
Sequelize.DECIMAL                  # DECIMAL
Sequelize.DECIMAL 10,2             # DECIMAL(10,2)
 
Sequelize.DATE                     # DATETIME for mysql / sqlite, TIMESTAMP WITH TIME ZONE for postgres
Sequelize.BOOLEAN                  # TINYINT(1)
 
Sequelize.ENUM 'value 1','value 2' # An ENUM with allowed values 'value 1' and 'value 2'
Sequelize.ARRAY Sequelize.TEXT     # Defines an array. PostgreSQL only.
 
Sequelize.BLOB                     # BLOB (bytea for PostgreSQL)
Sequelize.BLOB 'tiny'              # TINYBLOB (bytea for PostgreSQL. Other options are medium and long)
Sequelize.UUID                     # UUID datatype for PostgreSQL and SQLite, CHAR(36) BINARY for MySQL
                                   # (use defaultValue: Sequelize.UUIDV1 or Sequelize.
                                   # UUIDV4 to make sequelize generate the ids automatically)
```
## [Association][4]
## [Validation][5]

# Via
* [Sequelize API](http://sequelize.readthedocs.org/en/latest/api/sequelize/)
* [Sequelize Upgrading to 2.0 - github sequelize Wiki(2014-12-24)](https://github.com/sequelize/sequelize/wiki/Upgrading-to-2.0)
* [Sequelize cheatsheet by Rico Sta. Cruz](http://ricostacruz.com/cheatsheets/sequelize.html)
* [Sequelizeを使用してデータベースを操作するための基本的な情報 by @mima_ita](http://qiita.com/mima_ita/items/014dcb42872f3a10855b)

# License
  MIT License by 59naga@horse_n_deer, 2015-01-07

[1]: http://sequelize.readthedocs.org/en/latest/docs/usage/#options
[2]: http://sequelize.readthedocs.org/en/latest/docs/models/
[3]: http://sequelize.readthedocs.org/en/latest/docs/models/#data-types
[4]: http://example.com
[5]: http://example.com