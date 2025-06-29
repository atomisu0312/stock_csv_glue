from pyspark.sql.functions import udf
from pyspark.sql.types import DateType
from datetime import datetime
import re

def parse_date_string(date_str):
    """
    'Apr 26, 2024'のような文字列をDate型に変換する関数
    
    Args:
        date_str (str): 'MMM dd, yyyy'形式の日付文字列
        
    Returns:
        datetime.date: パースされた日付、パースできない場合はNone
    """
    if not date_str:
        return None
    
    try:
        # 月の略称を数字にマッピング
        month_map = {
            'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
            'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
        }
        
        # 正規表現でパース
        pattern = r'^([A-Za-z]{3})\s+(\d{1,2}),\s+(\d{4})$'
        match = re.match(pattern, date_str.strip())
        
        if match:
            month_str, day_str, year_str = match.groups()
            month = month_map.get(month_str)
            day = int(day_str)
            year = int(year_str)
            
            if month and 1 <= day <= 31 and 1900 <= year <= 2100:
                return datetime(year, month, day).date()
        
        return None
        
    except Exception:
        return None

# UDFとして登録
parse_date_udf = udf(parse_date_string, DateType())
