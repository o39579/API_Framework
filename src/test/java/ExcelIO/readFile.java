package ExcelIO;

import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.Map;

public class readFile {
    public static final String testDateFileName = "./Data/TestData.xlsx";
    public static FileInputStream fis;
    public static XSSFWorkbook workbook;
    public static XSSFSheet worksheet;
    public static XSSFRow row;
    public static XSSFRow headerRow;

    public void loadFile(){
        try {
            System.out.println("Loading Excel Data....");
            File file = new File(testDateFileName);
            fis = new FileInputStream(file);
            workbook = new XSSFWorkbook(fis);
            worksheet = workbook.getSheet("TestCase");
            fis.close();
        } catch (Exception e) {
            System.out.println("Unable to load file.. Please save and close Test Data file");
        }
    }
    public Map<String, Map<String, String>> getDataMap(String testcase){
        Map<String, Map<String, String>> superMap = new HashMap<String, Map<String, String>>();
        try{
            if(worksheet == null)
                loadFile();
            headerRow=worksheet.getRow(0);
            for(int i=1;i<(worksheet.getLastRowNum()+1);i++){
                row=worksheet.getRow(i);
                String testcaseName= row.getCell(0).toString();
                Map<String, String> myMap=new HashMap<String, String>();
                for(int j=1;j<row.getLastCellNum();j++){
                    String KeyCell= headerRow.getCell(j).toString();
                    String value = row.getCell(j).toString();
                    if(KeyCell.equals("status"))
                        value = value.substring(0,3);
                    if(KeyCell.equals("BottlerSpecificId")) {
                        //String[] param = value.split(".");
                        value = value.substring(0,4);
                    }
                    if(KeyCell.equals("request") || KeyCell.equals("response")){
                        value = value.replace("\n", "");
                        value = value.replace("\t", "");
                        //value = value.replace("\"", "");
                        //value = value.replace(" ", "");
                    }
                    if(!value.equals(""))
                        myMap.put(KeyCell,value);
                }
                superMap.put(testcaseName,myMap);
            }
        }catch(Exception e){
            System.out.println("Read Data Exception.. Please provide correct values in Test Data file...");
        }
        return superMap;
    }
    public String getValue(String testcase, String value){
        return getDataMap(testcase).get(testcase+"").get(value+"");
    }
    public Map<String, Map<String, String>> getMap(String testcase){
        return getDataMap(testcase);
    }
    public Map<String, String> getTestData(String testcase){
        return getDataMap(testcase).get(testcase+"");
    }
    public Map<String, String> getRequestData(String testcase){
        return getDataMap(testcase).get("request");
    }
    public Map<String, String> getResponseData(String testcase){
        return getDataMap(testcase).get("response");
    }
    public Map<String, String> getURLParam(String testcase){
        return getDataMap(testcase).get("param");
    }
}

