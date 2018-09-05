package com.dmcc.pagegen.tags.generic;

import static com.dmcc.utils.io.Io.debug;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.openqa.selenium.internal.seleniumemulation.GetConfirmation;

import com.dmcc.pagegen.exceptions.PageElementParseException;
import com.dmcc.pagegen.tags.parent.ByTypeEnum;
import com.dmcc.pagegen.tags.parent.Tag;

public class Select extends Tag {

	@Override
	protected String getCompleteElementSearchExpression() throws PageElementParseException {
		return getElementWithChildElementsExpression(this.getTagName());
	}
	
	@Override
	protected boolean tidy(final String attrs, final String data) {
		
		Pattern p = Pattern.compile("<option[^>]*>(.*?)(</option>)");
		
		Matcher m = p.matcher(data);
		
		ByTypeEnum byType=getByType();
		
		boolean isTidy=true;
		
		if(byType!=null){
			if(byType.equals(ByTypeEnum.name) || byType.equals(ByTypeEnum.id) ){
				setName(getByExpr());
				
				while(m.find()){
						String optionvalue=m.group(1).replace("\n", "").trim();
		
						if(optionvalue.contains(">") && optionvalue.contains("<")){
							isTidy=false; break;
						}
						
						if( !getOptions().contains(optionvalue) ){
							getOptions().add(optionvalue);
						}
				}
			}
		}
		else
		{
			isTidy=false;
		}
		
		return isTidy;
	}

	@Override
	public String toString(){
		
		StringBuffer buffer = new StringBuffer();
		
		if( isClean() )
		{
			buffer.append("\t\t{\n");
			buffer.append("\t\t\t\"name\" : \""+this.getName()+"\",\n");
			buffer.append("\t\t\t\"byExpr\" : \""+this.getByExpr()+"\",\n");
			buffer.append("\t\t\t\"byType\" : \""+this.getByType()+"\",\n");
			buffer.append("\t\t\t\"htmlType\" : \""+this.getHtmlType()+"\"");
			
			if(getOptions().size()>0){
				buffer.append(",\n");
				buffer.append("\t\t\t\"options\" : [\n");
					
				int count=0;
				
				for(String option :getOptions()){
					buffer.append("\t\t\t\t\""+option+"\"");
					
					if(count<(getOptions().size()-1)){
						buffer.append(",\n");
					}
					else
					{
						buffer.append("\n");
					}
					
					++count;
				}
				
				buffer.append("\t\t\t]\n");
			}
			else
			{
				buffer.append("\n");
			}
			
			buffer.append("\t\t}\n");
		}
		
		return buffer.toString();
	}
}
