----------------------------------------
-- 이 주석은 삭제하지 마세요.
-- 35% 할인해 드립니다. 코로나 계정 유료 구매시 연락주세요. (Corona SDK, Enterprise, Cards)
-- @Author 아폴로케이션 원강민 대표
-- @Website http://WonHaDa.com, http://Apollocation.com, http://CoronaLabs.kr
-- @E-mail englekk@naver.com, englekk@apollocation.com
-- 'John 3:16, Psalm 23'
-- MIT License :: WonHada Library에 한정되며, 라이선스와 저작권 관련 명시만 지켜주면 되는 라이선스
----------------------------------------

if system.getInfo("model") == nil then return end -- for HTML5

local aspectRatio = display.pixelHeight / display.pixelWidth

application =
{
  content =
  {
    width = aspectRatio > 1.5 and 360 or math.ceil( 480 / aspectRatio ),
    height = aspectRatio < 1.5 and 480 or math.ceil( 360 * aspectRatio ),
    scale = "letterBox",
    audioPlayFrequency = 44100, -- 11025, 22050, 44100: 높을수록 고음질
    fps = 60,
    xAlign = "left",
    yAlign = "top",
    imageSuffix =
    {
      ["@2x"] = 1.5,
      ["@4x"] = 3.0,
    },
  },
  --[[notification =
  {
    iphone =
    {
      types =
      {
        "badge", "sound", "alert"
      }
    },
    google =
    {
      projectNumber = "000000000000"
    },
  }]]
}