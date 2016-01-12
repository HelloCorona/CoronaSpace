local sqlite3 = require( "sqlite3" )

-- 파일이 존재하는지 체크
local function fileExists(fileName, base)
  local filePath = system.pathForFile( fileName, base )
  local exists = false

  if (filePath) then
    local fileHandle = io.open( filePath, "r" )
    if (fileHandle) then
      exists = true
      io.close(fileHandle)
    end
  end
  
  return exists
end

local Class = {}

Class.db = nil

-- DB 연결
Class.connectDB = function (dbFile, baseDir)
    local exists = fileExists(dbFile, baseDir) -- 파일이 기존에 존재했는지 체크
    
    local path = system.pathForFile( dbFile, baseDir )
    Class.db = sqlite3.open( path )

    local sql = [[CREATE TABLE `config` (
            `idx`	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
            `key`	TEXT UNIQUE,
            `value`	TEXT
    )]]
    Class.query(sql)
    
    return exists
end

-- 쿼리
Class.query = function (sql, func, udata)
        Class.db:exec(sql, func, udata)
end

-- Config 테이블 업데이트
Class.setConfig = function (key, value)
        local keyExists = false

        local sql = [[SELECT * FROM config WHERE key=']]..key..[[']]
        for row in Class.db:nrows(sql) do
                keyExists = true
                break
        end
        if keyExists == true then
                Class.query([[UPDATE config SET value=']]..value..[[' WHERE key=']]..key..[[']])
        else
                if value ~= nil then
                        Class.query([[INSERT INTO config VALUES (NULL, ']]..key..[[',']]..value..[[')]])
                end
        end
end

-- Config 테이블 내용 가져오기
Class.getConfig = function (key)
        local result = nil
        local sql = [[SELECT * FROM config WHERE key=']]..key..[[']]
        for row in Class.db:nrows(sql) do
                result = row.value
        end

        return result
end

return Class