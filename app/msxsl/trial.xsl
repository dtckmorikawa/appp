<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>

<!--Root Node-->
    <xsl:template match="/">
        <topic xml:lang="ja-JP">
            <xsl:attribute name="id">
                <xsl:value-of select=".//@id" />
            </xsl:attribute>
            <xsl:apply-templates/>
        </topic>
    </xsl:template>

<!--Level1-->
    <xsl:template match="title">
        <title>
            <xsl:value-of select="." />
        </title>
    </xsl:template>

    <xsl:template match="body">
        <body>
            <xsl:apply-templates/>
        </body>
    </xsl:template>

<!--Level2-->
    <xsl:template match="hr">
        <figure><image height='6' href='/var/www/html/webdita/public/blog_images/blueline-fullsize.png'/></figure>
    </xsl:template>

    <xsl:template match="h3">
        <p><b>
            <xsl:value-of select="." />
        </b></p>
    </xsl:template>

    <xsl:template match="p">
      <xsl:choose>
            <xsl:when test="./img">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>   

    <xsl:template match="ol">
        <ol>
            <xsl:apply-templates />
        </ol>
    </xsl:template>

    <xsl:template match="ul">
        <ul>
            <xsl:apply-templates />
        </ul>
    </xsl:template>

    <xsl:template match="blockquote">
        <note>
            <xsl:apply-templates />
        </note>
    </xsl:template>


<!--Level3-->
    <xsl:template match="li">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

<!--InLine Elements-->
    <!-- bold -->
    <xsl:template match="strong">
        <b>
            <xsl:value-of select="." />
        </b>
    </xsl:template>

    <!-- Underline -->
    <xsl:template match="u">
        <u>
            <xsl:value-of select="." />
        </u>
    </xsl:template>    
    
    <!-- sub script -->
    <xsl:template match="sub">
        <sub>
            <xsl:value-of select="." />
        </sub>
    </xsl:template>

    <!-- super script -->
    <xsl:template match="sup">
        <sup>
            <xsl:value-of select="." />
        </sup>
    </xsl:template>


    <!-- Internal link -->
    <xsl:template match="a">
        <xsl:variable name='dest-buf' select="./@href" />
        <xsl:choose>
            <!--web link-->
            <xsl:when test="starts-with($dest-buf, 'htt')">
                <xref>
                    <xsl:attribute name="href">
                        <xsl:value-of select="./@href" />
                    </xsl:attribute>
                    <xsl:value-of select="." />
                </xref>            
            </xsl:when>
            <!--internal xref link-->            
            <xsl:otherwise>
                <!--get topic id of the destination -->
                <xsl:variable name="link-dest-anchor" select="substring-after(./@href,'#')" />
                <!--get file name of the destination -->
                <xsl:variable name="link-dest-buf" select="substring-before(./@href,'-')" />
                <xsl:variable name="link-dest-filename" select="substring-after($link-dest-buf,'#')" />
        
                <xsl:variable name="link-dest" select="concat($link-dest-anchor,'.html.dita#',$link-dest-anchor)"/>
                <xref>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$link-dest" />
                    </xsl:attribute>
                    <xsl:value-of select="." />
                </xref>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- inline br &#10;-->
    <xsl:template match="br">
        <!--<xsl:text disable-output-escaping = "yes" >&amp;#10;</xsl:text>-->
        <br/>
    </xsl:template>

    <!-- Images (inline & block) -->
    <xsl:template match="img">
        <!--widthを取得-->
        <xsl:variable name="buf00" select="substring-after(.//@style, ';')"/>
        <xsl:variable name="buf01" select="substring-before($buf00, 'px')"/>
        <xsl:variable name="buf02" select="substring-after($buf01, ':')"/>
        
        <!--画像の位置を取得-->
        <xsl:variable name="imgbuf00" select="substring-after(.//@src,'https://dtcmanual.com/blog_images')"/> 
        <xsl:variable name="imgbuf01" select="concat('/var/www/html/webdita/public/blog_images', $imgbuf00)"/>
        <xsl:choose>
            <xsl:when test="$buf02 &lt; 21">
            <!--20px以下はインラインとして扱う(DITAはimgのみはInline扱い)-->
                <image>
                    <xsl:attribute name="width">
                        <xsl:value-of select="$buf02" />
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$imgbuf01" />
                        </xsl:attribute>
                </image>
            </xsl:when>
            <xsl:otherwise>
            <!--それ以外はfigをつけてブロック画像として扱う-->
                <fig><image>
                    <!--　Auto-Fit-To-Page指定なのでWidth不要
                    <xsl:attribute name="width"> 
                        <xsl:value-of select="$buf02" />
                    </xsl:attribute>-->
                    <xsl:attribute name="href">
                        <xsl:value-of select="$imgbuf01" />
                    </xsl:attribute>
                </image></fig>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Video -->
    <xsl:template match="video">
        <!-- 動画の位置を取得 -->
        <xsl:variable name="vdobuf00" select="substring-after(.//@src,'https://dtcmanual.com/blog_videos')"/> 
        <xsl:variable name="vdobuf01" select="concat('/var/www/html/webdita/public/blog_videos', $vdobuf00)"/>
        
        <!-- 拡張子抜きのファイル名を取得 -->
        <xsl:variable name="file-name" select="substring-before($vdobuf01,'.mp4')"/>

        <p>画像をクリックするとブラウザが開き動画が再生されます</p>
        <xref>
            <xsl:attribute name="href">
                <xsl:value-of select=".//@src" />
            </xsl:attribute>
            <image>
                <xsl:attribute name="href">
                    <!-- サムネイル指定 -->
                    <xsl:value-of select="concat($file-name, '.png')" />
                </xsl:attribute>
            </image>
        </xref>
    </xsl:template>

    <!--Table-->
    <xsl:template match="table">
        <table>
            <xsl:if test="count(./thead) &gt; 0">
              <title>
                <xsl:value-of select="./caption" />
              </title>
            </xsl:if>
            <tgroup>
                <xsl:attribute name="cols">
                    <xsl:choose>
                        <!--no header-->
                        <xsl:when test="count(./thead) = 0">
                            <xsl:value-of select="count(./tbody/tr[1]/td)" />
                        </xsl:when>
                        <!--with header-->
                        <xsl:otherwise>
                            <xsl:value-of select="count(./thead/tr/th)" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:apply-templates/>
            </tgroup>
        </table>
    </xsl:template>

    <xsl:template match="thead">
        <thead>
            <xsl:apply-templates/>
        </thead>            
    </xsl:template>

    <xsl:template match="tbody">
        <tbody>
            <xsl:apply-templates/>
        </tbody>
    </xsl:template>

    <xsl:template match="th">
        <thead>
            <xsl:apply-templates/>
        </thead>
    </xsl:template>

    <xsl:template match="tr">
        <row rowsep="1">
            <xsl:apply-templates/>
        </row>
        <!--<xsl:choose>
            <xsl:when test="parent::thead">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <stentry>
                    <xsl:apply-templates/>
                </stentry>
            </xsl:otherwise>
        </xsl:choose>-->
    </xsl:template>

    <xsl:template match="td">
        <entry colsep="1">
            <xsl:apply-templates/>
        </entry>
    </xsl:template>

    <xsl:template match="th">
        <entry colsep="1">
            <xsl:apply-templates/>
        </entry>
    </xsl:template>

</xsl:stylesheet>