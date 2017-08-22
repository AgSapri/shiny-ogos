//+------------------------------------------------------------------+
//|                                                 Telegram4MQL.mq4 |
//|                                                   steven england |
//|           mailto:                                                |
//|         homepage: telegram4mql.steven-england.de                 |
//+------------------------------------------------------------------+
#property copyright "steven england"
#property link      "mailto:"
#property version   "1.00"
//--- input parameters
//input int      testparam;


#property description "The Expert Advisor demonstrates how to create a series of screenshots of the current"
#property description "chart using the ChartScreenShot() function. For convenience, the file name is"
#property description "shown on the chart. The height and width of images is defined through macros."
//---
#define        WIDTH  800     // Image width to call ChartScreenShot()
#define        HEIGHT 600     // Image height to call ChartScreenShot()
//--- input parameters
input int      pictures=5;    // The number of images in the series
int            mode=-1;       // -1 denotes a shift to the right edge of the chart, 1 - to the left
int            bars_shift=300;// The number of bars when scrolling the chart using ChartNavigate()

#import "Telegram4Mql.dll"
   string TelegramSendScreenAsync(string apiKey, string chatId, string caption = "");
   string TelegramSendScreen(string apiKey, string chatId, string caption = "");
   string TelegramGetUpdates(string apiKey, string validUsers, bool confirmUpdates);
   string TelegramSendPhoto(string apiKey, string chatId, string filePath, string caption = "");
   string TelegramSendPhotoAsync(string apiKey, string chatId, string filePath, string caption = "");
#import



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void OnInit()
  {
 string apiKey = "token";
 string chatId = "token";
  int i = 1;
//---
   Print(TelegramSendScreen(apiKey, chatId, "test screen") + " screen");
   Print("screen sent");
   Print(TelegramGetUpdates(apiKey, chatId, false));
   Print(TelegramGetUpdates(apiKey, chatId, true));
   Print(TelegramGetUpdates(apiKey, chatId, true));


//--- Disable chart autoscroll
   ChartSetInteger(0,CHART_AUTOSCROLL,false);
//--- Set the shift of the right edge of the chart
   ChartSetInteger(0,CHART_SHIFT,true);
//--- Show a candlestick chart
   ChartSetInteger(0,CHART_MODE,CHART_CANDLES);
//---
   Print("Preparation of the Expert Advisor is completed");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//--- Show the name of the function, call time and event identifier
   Print(__FUNCTION__,TimeCurrent(),"   id=",id,"   mode=",mode);
//--- Handle the CHARTEVENT_CLICK event ("A mouse click on the chart")
   if(id==CHARTEVENT_CLICK)
     {
      //--- Initial shift from the chart edge
      int pos=0;
      //--- Operation with the left chart edge
      if(mode>0)
        {
         //--- Scroll the chart to the left edge
         ChartNavigate(0,CHART_BEGIN,pos);
         for(int i=0;i<pictures;i++)
           {
            //--- Prepare a text to show on the chart and a file name
            string name="ChartScreenShot"+"CHART_BEGIN"+string(pos)+".gif";
            //--- Show the name on the chart as a comment
            Comment(name);
            //--- Save the chart screenshot in a file in the terminal_directory\MQL4\Files\
            if(ChartScreenShot(0,name,WIDTH,HEIGHT,ALIGN_LEFT))
               Print("We've saved the screenshot ",name);
            //---
            pos+=bars_shift;
            //--- Give the user time to look at the new part of the chart
            Sleep(3000);
            //--- Scroll the chart from the current position bars_shift bars to the right
            ChartNavigate(0,CHART_CURRENT_POS,bars_shift);
           }
         //--- Change the mode to the opposite
         mode*=-1;
        }
     }  // End of CHARTEVENT_CLICK event handling
//--- End of the OnChartEvent() handler  
  }
