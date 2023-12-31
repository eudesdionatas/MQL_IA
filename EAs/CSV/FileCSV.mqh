//+------------------------------------------------------------------+
//|                                                     CFileCSV.mqh |
//|                                     Copyright 2021, Lethan Corp. |
//|                           https://www.mql5.com/pt/users/14134597 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Lethan Corp."
#property link      "https://www.mql5.com/pt/users/14134597"
#property version   "1.01"

#include <Files\File.mqh>
//+------------------------------------------------------------------+
//| Class CFileCSV                                                   |
//| Purpose: Class of operations with CSV files.                     |
//|          Derives from class CFile.                               |
//+------------------------------------------------------------------+
class CFileCSV : public CFile
{
   private:
      template<typename T>
      string            ToString(const int, const T &[][]);
      template<typename T>
      string            ToString(const T &[]);
      short             m_delimiter;
   
   public:
      CFileCSV(void);
      ~CFileCSV(void);
      
      //--- methods for working with files
      int               Open(const string, const int, const short);
      
      template<typename T>
      uint              WriteHeader(const T &values[]);
      
      template<typename T>
      uint              WriteLine(const T &values[][]);
      
      string            Read(void);
};  

//+------------------------------------------------------------------+
//| Constructor                                                      |  
//+------------------------------------------------------------------+
CFileCSV::CFileCSV(){}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CFileCSV::~CFileCSV(){}

//+------------------------------------------------------------------+
//| Open the text file                                               |
//+------------------------------------------------------------------+
int CFileCSV::Open(const string file_name,
                   const int    open_flags,
                   const short  delimiter = ';')
{
   m_delimiter = delimiter;
   
   return(CFile::Open(file_name, open_flags|FILE_CSV|delimiter));
}

//+------------------------------------------------------------------+
//| Writing string to file                                           |
//+------------------------------------------------------------------+
template<typename T>
uint CFileCSV::WriteHeader(const T &values[])
{
   string header = ToString(values);
   
   //--- check handle
   if(m_handle != INVALID_HANDLE)
      return(::FileWrite(m_handle, header));
   
   //--- failure
   return(0);
}

//+------------------------------------------------------------------+
//|   Writing matrix to file                                         |
//+------------------------------------------------------------------+
template<typename T>
uint CFileCSV::WriteLine(const T &values[][])
{
   int len = ArrayRange(values, 0);
   
   if(len < 1)
      return 0;
   
   string lines = "";
   for(int i = 0; i < len; i++)
   {
      if(i < len-1)
         lines += ToString(i, values)  + "\n";
      else
         lines += ToString(i, values);
   }
   
   if(m_handle != INVALID_HANDLE)
      return(::FileWrite(m_handle, lines));
   
   return 0;
}

//+------------------------------------------------------------------+
//| Transform matrix in string                                       |
//+------------------------------------------------------------------+
template<typename T>
string CFileCSV::ToString(const int row, const T &values[][])
{
   string res = "";
   int cols = ArrayRange(values, 1);
   
   for(int x = 0; x<cols; x++)
   {
      if(x < cols-1)
         res += values[row][x] + ShortToString(m_delimiter);
      else
         res += values[row][x];
   }
   
   return res;
}

//+------------------------------------------------------------------+
//| Transform array values in string                                 |
//+------------------------------------------------------------------+
template<typename T>
string CFileCSV::ToString(const T &values[])
{
   string res="";
   int len=ArraySize(values);
   
   if(len<1)
      return res;
   
   for(int i = 0; i<len; i++)
   {
      if(i < len-1)
         res += values[i] + ShortToString(m_delimiter);
      else
         res += values[i];
   }
   
   return res;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CFileCSV::Read(void)
{
   string res="";
   
   if(m_handle != INVALID_HANDLE)
      res = FileReadString(m_handle);
   
   return res;
}