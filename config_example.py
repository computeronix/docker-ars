from lib.pairs import Pair
from lib.pairs import pairs
TG_ENABLED=True
TG_VERBOSE="Full"
GUNBOT_CONFIG_FILE="config.js"
GUNBOT_JSON_DIR="json"
LOG_FILE="logging.txt"
CHECK_DELAY = 5
STAT_MSG_TIMEOUT = 15
UV_FILE = "USR_VARS.ini"
ISL = False
ISL_LIMIT = 60
LIQ = True
AP_COUNT_DELIM = 1000
AP_AUTO_COUNT = False
AP_COUNT = 14
MM_STRAT_NAME = "mm"

def newPair (pair_name, **args):
    pair = Pair(pair_name)
    pair.settings.MOTO_STRAT = True
    pair.settings.S_STRAT = "moto"
    pair.settings.NS_STRAT = "moto"
    pair.settings.PERIOD = 5
    pair.settings.SMAPERIOD = 50
    pair.settings.MAX_BUY = 0
    pair.settings.MAX_SELL = 0
    pair.settings.DCA_METHOD = "NATIVE"
    pair.settings.MOTO_DCA_PERC = 1.25
    pair.settings.MAX_OPEN_CONTRACTS = 10000000
#LL don't use below 60 or else Happy REKT time    
    pair.settings.LIQUIDATION_LIMIT = 60
    pair.settings.MOTO_SIDE_SWITCH = True
    pair.settings.DYNAMIC_ROE = False
#ROE METHODS and VALUES 
    pair.config.ROE_TRAILING = True
    pair.settings.ROE = 19
    pair.settings.ROE_LOW = 16
    pair.settings.ROE_LIMIT = 2
    pair.settings.ROE_SCALPER_PDP = False
    pair.settings.TL_AC = True
    pair.settings.TL_FACTOR = 8
    pair.settings.TLX = 2
    pair.settings.TLX_OPEN = 1
#protections    
    pair.settings.PPP = True
    pair.settings.PPP_UPNL_LIMIT = -0.5
    pair.settings.PDP = False
    pair.settings.SPK = False
    pair.settings.SPK_KILL = -1
    pair.settings.SPK_TIME = 60
#Don't never ever TOUCH, better stop_loss than get the email from CZ    
    pair.settings.STOP_LOSS = True
#para el wallet pequeño poner True - Small wallet below 5000 use True
    pair.settings.SL_HL = False
    pair.settings.SL_LL = True
    pair.settings.SL_LIMIT = 10
    pair.settings.SL_TIME = 120
    pair.settings.SL_MAX = 11.5
    pair.settings.UPNLK = False
    pair.settings.POS_LIM = False
    pair.config.MARKET_CLOSE = True
    pair.settings.GRID_SPREAD_NO_CONFIRMED = 0.4
    pair.settings.GRID_SPREAD_CONFIRMED = 0.2
    pair.settings.MOTO_SIDE_SWITCH = True
    pair.settings.MOTO_TIMER = 750
    pair.settings.MOTO_TIMER_V8 = 600
    pair.settings.PND = False
    pair.settings.PND_ON = False
    pair.settings.PND_PROTECTION = 2
    pair.settings.IAPK = False
    pair.settings.IAPK_TIME = 30
    pair.settings.IAPK_LIM = -0.25
    pair.settings.SR_SWITCH = False   
    pair.settings.ROE_SCALPER = True
    pair.settings.STATS_DTIME = 24
    pair.settings.FTT = True
    pair.settings.FTT_SR_SPREAD = 0.05
    pair.settings.uPNLK = False
    pair.settings.uPNLK_RERUN = False
    pair.settings.uPNLK_LIM = -9
    pair.settings.uPNLK_LS = 101
    pair.settings.FTT_UPNL_LIM = -2
    pair.settings.FTT_SRLL = 4
    pair.settings.FTT_SRLS = 4
    pair.settings.TT_LOCK = 4
    pair.settings.ERGO_TRAIL = False
    pair.settings.STATS_DTIME = 24


    for item in args.items():
        setattr(pair.settings, item[0], item[1])
    return pair
    
    
#example manual pair     
pairs.append(newPair("USDT-ADA"))

