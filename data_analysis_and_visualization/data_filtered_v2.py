import os
import fnmatch
import pandas as pd

# 文件夹路径
folder_path = '/Users/zdliu/Desktop/605_2024fall/Data_new'

# 要查找的文件名标识符列表
identifiers = [
    '4616337', '4616338', '4620331', '4616324', '4616323', '4620332', '4456494', '4620314', '4616325', '4616357',
    '4616267', '4620330', '4620315', '4616223', '4616310', '4329508', '4616309', '4616282', '4616271', '4616210'
]

# 获取文件夹内的csv文件并筛选出符合条件的文件
matching_files = []
for file_name in os.listdir(folder_path):
    if file_name.endswith('.csv'):
        for identifier in identifiers:
            if identifier in file_name:
                matching_files.append(os.path.join(folder_path, file_name))
                break

# 拼接符合条件的csv文件
if matching_files:
    filtered_dfs = []
    for file in matching_files:
        df = pd.read_csv(file)
        # 将DATA_AS_OF列转换为datetime格式并筛选日期范围内的数据
        df['DATA_AS_OF'] = pd.to_datetime(df['DATA_AS_OF'], format='%m/%d/%Y %I:%M:%S %p')
        df_filtered = df[(df['DATA_AS_OF'] >= '2019-01-01') & (df['DATA_AS_OF'] <= '2020-12-31')]
        filtered_dfs.append(df_filtered)
    
    # 合并所有符合条件的数据
    combined_df = pd.concat(filtered_dfs, ignore_index=True)
    # 保留所需的列
    columns_to_keep = ['SPEED', 'DATA_AS_OF', 'LINK_POINTS', 'LINK_NAME', 'BOROUGH']
    combined_df = combined_df[columns_to_keep]
    # 保存拼接后的文件
    combined_df.to_csv('combined_output_v2.csv', index=False)
    print("拼接后的文件已保存为 combined_output_v2.csv")
else:
    print("未找到符合条件的文件")
