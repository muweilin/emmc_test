#include <stdio.h>
#include "gpio.h"
#include "uart.h"
#include "oled.h"
#include "oledfont.h" 
#include "spi.h"
u16 dis_line = 15;
u16 BACK_COLOR, POINT_COLOR;  
void delay_ms(volatile int delay)
{
    volatile int i;
    delay = delay * 400;
    for(i = 0; i < delay; i++) asm volatile("nop");
}
void LCD_Writ_Bus(char dat)   //串行数据写入
{	
	u8 i;			  
  

	for(i=0;i<8;i++)
	{			  
		OLED_SCLK_Clr();
		if(dat&0x80)
		   OLED_SDIN_Set();
		else 
		   OLED_SDIN_Clr();
		OLED_SCLK_Set();
		dat<<=1;
	}			
}
void LCD_WR_DATA8(char da) 
{	
	OLED_DC_Set();
	spi1_setup_cmd_addr(da, 8, 0, 0);
 	spi1_start_transaction(SPI_CMD_WR, SPI_CSN0);
        //OLED_CS_Clr();
        //OLED_DC_Set();
	//LCD_Writ_Bus(da);  
	//OLED_CS_Set();
}  
 void LCD_WR_DATA(u32 da)
{	
	OLED_DC_Set();
	spi1_setup_cmd_addr(da, 24, 0, 0);
 	spi1_start_transaction(SPI_CMD_WR, SPI_CSN0);
        //OLED_CS_Clr();
	//OLED_DC_Set();
	//LCD_Writ_Bus(da>>8);
    	//LCD_Writ_Bus(da);
	//OLED_CS_Set();
}	  
void LCD_WR_REG(char da)	 
{	
	OLED_DC_Clr();
	spi1_setup_cmd_addr(da, 8, 0, 0);
 	spi1_start_transaction(SPI_CMD_WR, SPI_CSN0);
        //OLED_CS_Clr();
   	//OLED_DC_Clr();
	//LCD_Writ_Bus(da);
	//OLED_CS_Set();
}
 void LCD_WR_REG_DATA(int reg,int da)
{	OLED_CS_Clr();
    	LCD_WR_REG(reg);
	LCD_WR_DATA(da);
	OLED_CS_Set();
}
void Address_set(unsigned int x1,unsigned int y1,unsigned int x2,unsigned int y2)
{ 
   LCD_WR_REG(0x2a);//sety
   LCD_WR_DATA8(x1>>8);
   LCD_WR_DATA8(x1&0xFF);
   LCD_WR_DATA8(x2>>8);
   LCD_WR_DATA8(x2);
  
   LCD_WR_REG(0x2b);//setx
   LCD_WR_DATA8(y1>>8);
   LCD_WR_DATA8(y1&0xFF);
   LCD_WR_DATA8(y2>>8);
   LCD_WR_DATA8(y2);

   LCD_WR_REG(0x2C);	//wram				 					 
}

void Lcd_Init(void)
{
	set_gpio_pin_direction(0, 1); //CLK
	set_gpio_pin_direction(1, 1); //MOSI
	set_gpio_pin_direction(2, 1); //DC
	set_gpio_pin_direction(3, 1); //RES
	set_gpio_pin_direction(4, 1); //MISO
	set_gpio_pin_direction(5, 1); //CS
 	set_gpio_pin_value(0, 1);
	set_gpio_pin_value(1, 1);
	set_gpio_pin_value(2, 1);
	set_gpio_pin_value(3, 1);
	set_gpio_pin_value(4, 1);
	set_gpio_pin_value(5, 1);
	*(volatile int*)(SPI1_REG_CLKDIV) = 0x02;

        OLED_RST_Set();
        delay_ms(20);
	//OLED_CS_Clr();  //打开片选使能
	OLED_RST_Clr();
	delay_ms(120);
	OLED_RST_Set();
	delay_ms(120);
	
//************* Start Initial Sequence **********// 
spi1_set_datalen(0);
spi1_setup_dummy(0, 0);
LCD_WR_REG(0x11); 
delay_ms(120);
//LCD_WR_REG(0x13);
//delay_ms(120);
 
LCD_WR_REG(0xD0); 
LCD_WR_DATA8(0x07); 
LCD_WR_DATA8(0x41); 
LCD_WR_DATA8(0X1E); 
 
LCD_WR_REG(0xD1);  
LCD_WR_DATA8(0x00); 
LCD_WR_DATA8(0x18); 
LCD_WR_DATA8(0X1F);  
 
LCD_WR_REG(0xD2);  
LCD_WR_DATA8(0x01); 
LCD_WR_DATA8(0x12);  
 
LCD_WR_REG(0xC0);  
LCD_WR_DATA8(0x10); 
LCD_WR_DATA8(0x3B); 
LCD_WR_DATA8(0x00); 
LCD_WR_DATA8(0x02); 
LCD_WR_DATA8(0x11); 

LCD_WR_REG(0xC1);  
LCD_WR_DATA8(0x10); 
LCD_WR_DATA8(0x13); 
LCD_WR_DATA8(0x88); 

LCD_WR_REG(0xC5);  
LCD_WR_DATA8(0x03);
 
//LCD_WR_REG(0xB4); 
//LCD_WR_DATA8(0x00);

LCD_WR_REG(0xC8); 
LCD_WR_DATA8(0x00); 
LCD_WR_DATA8(0x23); 
LCD_WR_DATA8(0x44); 
LCD_WR_DATA8(0x11); 
LCD_WR_DATA8(0x07); 
LCD_WR_DATA8(0x1B); 
LCD_WR_DATA8(0x47); 
LCD_WR_DATA8(0x45); 
LCD_WR_DATA8(0x77);
LCD_WR_DATA8(0x01); 
LCD_WR_DATA8(0x07);
LCD_WR_DATA8(0x10);   


// Set address mode 
	LCD_WR_REG(0x0036);
	LCD_WR_DATA8(0x0020);
//	LCD_WR_DATA(0x0008);
	// Set pixel format 
	LCD_WR_REG(0x003a);
	//LCD_WR_DATA(0x0055);
	LCD_WR_DATA8(0x0066);
	// Set column address 
	LCD_WR_REG(0x002a);
	LCD_WR_DATA8(0x0000);
	LCD_WR_DATA8(0x0000);
	LCD_WR_DATA8(0x0001);
	LCD_WR_DATA8(0x00df);
	// Set page address 
	LCD_WR_REG(0x002b);
	LCD_WR_DATA8(0x0000);
	LCD_WR_DATA8(0x0000);
	LCD_WR_DATA8(0x0001);
	LCD_WR_DATA8(0x003f);
	// Delay 
	delay_ms(120);
	// Set display on 
	LCD_WR_REG(0x0029);
	delay_ms(120);
	//Write memory start 
	LCD_WR_REG(0x002c);
 
} 

//清屏函数
//Color:要清屏的填充色
void LCD_Clear(u32 color)
{
    u16 i,j;  	
    Address_set(0,0,LCD_W-1,LCD_H-1);
    OLED_DC_Set();
    for(i=0;i<LCD_W;i++)
	 {
	  for (j=0;j<LCD_H;j++)
	   {
 		//spi_setup_cmd_addr(Color, 16, 0, 0);
    		//spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
                LCD_WR_DATA(color);
                //LCD_WR_DATA8(green);
		//LCD_WR_DATA8(red);	 			 
	    }

	  }
}

//在指定位置显示一个汉字(32*33大小)
//dcolor为内容颜色，gbcolor为背静颜色
void showhanzi(unsigned int x,unsigned int y,unsigned char index)	
{  
	unsigned char i,j;
	unsigned char *temp=hanzi;    
    Address_set(x,y,x+31,y+31); //设置区域      
	temp+=index*128;	
	for(j=0;j<128;j++)
	{
		for(i=0;i<8;i++)
		{ 		     
		 	if((*temp&(1<<i))!=0)
			{
				LCD_WR_DATA(POINT_COLOR);
			} 
			else
			{
				LCD_WR_DATA(BACK_COLOR);
			}   
		}
		temp++;
	 }
}
//画点
//POINT_COLOR:此点的颜色
void LCD_DrawPoint(u16 x,u16 y)
{
	Address_set(x,y,x,y);//设置光标位置 
	LCD_WR_DATA(POINT_COLOR); 	    
} 	 
//画一个大点
//POINT_COLOR:此点的颜色
void LCD_DrawPoint_big(u16 x,u16 y)
{
	LCD_Fill(x-1,y-1,x+1,y+1,POINT_COLOR);
} 
//在指定区域内填充指定颜色
//区域大小:
//  (xend-xsta)*(yend-ysta)
void LCD_Fill(u16 xsta,u16 ysta,u16 xend,u16 yend,u16 color)
{          
	u16 i,j; 
	Address_set(xsta,ysta,xend,yend);      //设置光标位置 
	for(i=ysta;i<=yend;i++)
	{													   	 	
		for(j=xsta;j<=xend;j++)LCD_WR_DATA(color);//设置光标位置 	    
	} 					  	    
}  
//画线
//x1,y1:起点坐标
//x2,y2:终点坐标  
void LCD_DrawLine(u16 x1, u16 y1, u16 x2, u16 y2)
{
	u16 t; 
	u16 xerr=0,yerr=0,delta_x,delta_y,distance; 
	u16 incx,incy,uRow,uCol; 

	delta_x=x2-x1; //计算坐标增量 
	delta_y=y2-y1; 
	uRow=x1; 
	uCol=y1; 
	if(delta_x>0)incx=1; //设置单步方向 
	else if(delta_x==0)incx=0;//垂直线 
	else {incx=-1;delta_x=-delta_x;} 
	if(delta_y>0)incy=1; 
	else if(delta_y==0)incy=0;//水平线 
	else{incy=-1;delta_y=-delta_y;} 
	if( delta_x>delta_y)distance=delta_x; //选取基本增量坐标轴 
	else distance=delta_y; 
	for(t=0;t<=distance+1;t++ )//画线输出 
	{  
		LCD_DrawPoint(uRow,uCol);//画点 
		xerr+=delta_x ; 
		yerr+=delta_y ; 
		if(xerr>distance) 
		{ 
			xerr-=distance; 
			uRow+=incx; 
		} 
		if(yerr>distance) 
		{ 
			yerr-=distance; 
			uCol+=incy; 
		} 
	}  
}    
//画矩形
void LCD_DrawRectangle(u16 x1, u16 y1, u16 x2, u16 y2)
{
	LCD_DrawLine(x1,y1,x2,y1);
	LCD_DrawLine(x1,y1,x1,y2);
	LCD_DrawLine(x1,y2,x2,y2);
	LCD_DrawLine(x2,y1,x2,y2);
}
//在指定位置画一个指定大小的圆
//(x,y):中心点
//r    :半径
void Draw_Circle(u16 x0,u16 y0,u8 r)
{
	int a,b;
	int di;
	a=0;b=r;	  
	di=3-(r<<1);             //判断下个点位置的标志
	while(a<=b)
	{
		LCD_DrawPoint(x0-b,y0-a);             //3           
		LCD_DrawPoint(x0+b,y0-a);             //0           
		LCD_DrawPoint(x0-a,y0+b);             //1       
		LCD_DrawPoint(x0-b,y0-a);             //7           
		LCD_DrawPoint(x0-a,y0-b);             //2             
		LCD_DrawPoint(x0+b,y0+a);             //4               
		LCD_DrawPoint(x0+a,y0-b);             //5
		LCD_DrawPoint(x0+a,y0+b);             //6 
		LCD_DrawPoint(x0-b,y0+a);             
		a++;
		//使用Bresenham算法画圆     
		if(di<0)di +=4*a+6;	  
		else
		{
			di+=10+4*(a-b);   
			b--;
		} 
		LCD_DrawPoint(x0+a,y0+b);
	}
} 
//在指定位置显示一个字符
//num:要显示的字符:" "--->"~"
//mode:叠加方式(1)还是非叠加方式(0)
void LCD_ShowChar(u16 x,u16 y,u8 num,u8 mode)
{
    u8 temp;
    u8 pos,t;
	u16 x0=x;
	u16 colortemp=POINT_COLOR;      
    if(x>LCD_W-16||y>LCD_H-16)return;	    
	//设置窗口		   
	num=num-' ';//得到偏移后的值
	Address_set(x,y,x+8-1,y+16-1);      //设置光标位置 
	if(!mode) //非叠加方式
	{
		for(pos=0; pos<16;pos++)
		{ 
			temp=asc2_1608[(u16)num*16+pos];		 //调用1608字体
			for(t=0;t<8;t++)
		    {                 
		        if(temp&0x01)POINT_COLOR=colortemp;
				else POINT_COLOR=BACK_COLOR;
				LCD_WR_DATA(POINT_COLOR);	
				temp>>=1; 
				x++;
		    }
			x=x0;
			y++;
		}	
	}else//叠加方式
	{
		for(pos=0;pos<16;pos++)
		{
		    temp=asc2_1608[(u16)num*16+pos];		 //调用1608字体
			for(t=0;t<8;t++)
		    {                 
		        if(temp&0x01)LCD_DrawPoint(x+t,y+pos);//画一个点     
		        temp>>=1; 
		    }
		}
	}
	POINT_COLOR=colortemp;	    	   	 	  
}   
//m^n函数
u32 mypow(u8 m,u8 n)
{
	u32 result=1;	 
	while(n--)result*=m;    
	return result;
}			 
//显示2个数字
//x,y :起点坐标	 
//len :数字的位数
//color:颜色
//num:数值(0~4294967295);	
void LCD_ShowNum(u16 x,u16 y,u32 num,u8 len)
{         	
	u8 t,temp;
	u8 enshow=0;
	num=(u16)num;
	for(t=0;t<len;t++)
	{
		temp=(num/mypow(10,len-t-1))%10;
		if(enshow==0&&t<(len-1))
		{
			if(temp==0)
			{
				LCD_ShowChar(x+8*t,y,' ',0);
				continue;
			}else enshow=1; 
		 	 
		}
	 	LCD_ShowChar(x+8*t,y,temp+48,0); 
	}
} 
//显示2个数字
//x,y:起点坐标
//num:数值(0~99);	 
void LCD_Show2Num(u16 x,u16 y,u16 num,u8 len)
{         	
	u8 t,temp;						   
	for(t=0;t<len;t++)
	{
		temp=(num/mypow(10,len-t-1))%10;
	 	LCD_ShowChar(x+8*t,y,temp+'0',0); 
	}
} 
//显示字符串
//x,y:起点坐标  
//*p:字符串起始地址
//用16字体
void LCD_ShowString(u16 x,u16 y,const u8 *p)
{         
    while(*p!='\0')
    {       
        if(x>LCD_W-16){x=0;y+=16;}
        if(y>LCD_H-16){y=x=0;LCD_Clear(BACK_COLOR);}
        LCD_ShowChar(x,y,*p,0);
        x+=8;
        p++;
    }  
}

void display_shade(u16 x1)
{
	u16 i,j; 
	u32 pixel;
	u8 b;
	Address_set(x1,10,x1 + 34, 309);
	for(i = 0; i < 300; i++){
	   b=255;
	   for (j=0;j<35;j++){  
		if(b>100)
		b-=15;
		else if(b>6)
		b-=5;
	  
		//if(b>=0xfc)
		//pixel = ((b << 16) | 0xfcfc);
		//else if(b>=0xf6)
		//pixel = ((b << 16) | 0xf6f6);
		//else
		pixel = ((b << 16) | 0x0000);    
		LCD_WR_DATA(pixel);
		}
	}
}

void display_image(u16 x1, u16 y1, u16 x2, u16 y2, volatile unsigned char* image_addr)
{
	u16 i,j,xl,yl; 
	u32 pixel;
	Address_set(x1,y1,x2,y2);
	xl = x2 - x1;
	yl = y2 - y1;
	for(i=0;i<yl;i++){
	   for (j=0;j<xl;j++){    
	pixel = (((*(image_addr)) << 16) | ((*(image_addr + 1)) << 8) | (*(image_addr + 2)));    
		//LCD_WR_DATA8(*image_addr);
		//LCD_WR_DATA8(*(image_addr + 1));
	LCD_WR_DATA(pixel);
	image_addr += 3;
		}
	}
}

void display_cam(volatile unsigned char* image_addr)
{
    u16 i,j;  		
    //u32 pixel;
    Address_set(0,0,LCD_W-1,LCD_H-1);
    OLED_DC_Set();
    volatile unsigned char* image_addr_ver = image_addr;
	for(i=0;i<320;i++)
	 {
	image_addr_ver = image_addr + i*1280;
	  for (j=0;j<480;j++)
	   {
		//pixel = ((*(image_addr_ver + 1) << 3) << 16) | ((((*image_addr_ver) << 5) | ((*(image_addr_ver + 1) & 0xE0) >> 3))<< 8) | (((*image_addr_ver) & 0xF8));
		
		LCD_WR_DATA8((*(image_addr_ver + 1) << 3));
                LCD_WR_DATA8((((*image_addr_ver) << 5) | ((*(image_addr_ver + 1) & 0xE0) >> 3)));
		LCD_WR_DATA8(((*image_addr_ver) & 0xF8));

		//LCD_WR_DATA(pixel);

		image_addr_ver+=2;	 			 
	    }

	  }
}

void printf_lcd(const char* image_addr)
{
	if(dis_line > 300)
	{	
		LCD_Fill(145,0,479,319,WHITE);
		dis_line = 15;
	}
	LCD_ShowString(145,dis_line,image_addr);
	dis_line += 20;
}
































